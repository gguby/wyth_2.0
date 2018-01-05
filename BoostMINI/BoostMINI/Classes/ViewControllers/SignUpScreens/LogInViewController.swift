//
//  LogInViewController.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 26..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxOptional
import ReactorKit
import TransitionButton
import UIColor_Hex_Swift

/// 로그인 하기 전의 화면임.
class LogInViewController: UIViewController {

	@IBOutlet weak var loginButton: TransitionButton!
	@IBOutlet weak var testButton: TransitionButton!
	@IBOutlet weak var loginButtonView: UIView!
	@IBOutlet weak var tiltingView: TopTiltingView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		initUI()
		initEvents()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	override func viewDidAppear(_ animated: Bool) {
		self.navigationController?.isNavigationBarHidden = true
		super.viewDidAppear(animated)
		if tiltingView.isHidden {
			showStartAnimation()
		}
	}
	
	
	
	
	var disposeBag = DisposeBag()
	private func initUI() {
		if let lbl = view.viewWithTag(9001) as? UILabel {
			lbl.text = BSTFacade.localizable.login.smLoginText()
		}
	}

	
	func initEvents() {
		[loginButton, testButton].forEach { (bt: TransitionButton) in
			bt.rx.controlEvent([.touchDown, .touchUpInside, .touchUpOutside]).bind {
				// swap
				let dummy = bt.backgroundColor
				bt.backgroundColor = bt.tintColor
				bt.tintColor = dummy
				}.disposed(by: disposeBag)
		}
		//let userid = ""
		
//		do {
//            try self.openSmLogin()
//        } catch let error as LoginError {
//            error.cook(userid)
//        } catch let error {
//
//        }
		
		loginButton.rx.tap.bind {
			// 모양이 이상해 'ㅅ'
			do {
				try self.openSmLogin()
			} catch let error as LoginError {
				error.cook()
			} catch let error {
				logError(error.localizedDescription)
			}
			}.disposed(by: disposeBag)
		
		testButton.rx.tap.bind {
			self.testButton.startAnimation()
			RunInNextMainThread(withDelay: 0.666, { [weak self] in
				self?.testButton.stopAnimation(animationStyle: .expand, completion: {
					self?.goHome()
				})
			})
			}.disposed(by: disposeBag)

	}
}


extension LogInViewController {
	
	func showStartAnimation() {
		// 하단 하이라이트 삐딱하게 튀어나오도록 애니메이션
		tiltingView.isHidden = false
		
		let duration: TimeInterval = 1.3
		tiltingView.updateDisplayTiltMaskPercentage(1.0, 1.0)
		self.tiltingView.updateDisplayTiltMaskPercentage(1.0, 0.0, animation: true, duration: duration)
	}
	
	func goHome() {
		logVerbose("go home")

		guard let button = self.testButton else {
			LoginError.failedCode(-3).cook()
			//BSTError.login(LoginError.failedCode(-3)).cook(nil)
			return
		}
		// TODO : 최상위에서 랜딩 및 뷰를 관장하는 녀석이 있어야한다. (ReSwift에서 자동으로 되던 바로 그런 부분이다)
		
		let parent = self.parent
		
		self.dismiss(animated: false) {
			
			guard let vc = R.storyboard.home().instantiateInitialViewController() else {
				BSTFacade.ux.showToast(BSTFacade.localizable.error.viewControllerMissing("Home.initialViewController"))
				return
			}
			IntroViewController.actual!.present(vc, animated: false, completion: {
			})

		}

	}

	func openSmLogin() throws {
		
		logVerbose("sm login")
		
		guard let button = self.loginButton else {
            throw BSTError.login(LoginError.failedCode(-2))
//            BSTFacade.ux.showToast(BSTFacade.localizable.error.loginFailedCode(-2))
		}
		
		
		
		
		
		
		loginButtonView.hide()
		button.startAnimation()
		let qualityOfServiceClass = DispatchQoS.QoSClass.background
		let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
		backgroundQueue.async(execute: {

			var isFailed = false
			var html: String = ""
			//var isFailed = false
			// web preload
			do {
				let path = Definitions.externURLs.authUri
				html = try String(contentsOf: path.asUrl!, encoding: String.Encoding.utf8)
			} catch {
				BSTFacade.ux.showToast(BSTFacade.localizable.error.loginFailedCode(-1))
				isFailed = true
			}
			
			RunInNextMainThread {
				button.stopAnimation(animationStyle: .expand, completion: {
					self.loginButtonView.show()
					if isFailed {
						return
					}
					
					let newVC = SMLoginViewController.create("SignUp")
					//let newVC = R.storyboard.signUp.smLoginViewController()!
					if not(html.isEmpty) {
						newVC.preload = html
					}
					self.navigationController?.pushViewController(newVC, animated: true)
				})
			}
		})
	}
	
}
