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
	@IBOutlet weak var loginButtonView: UIView!
	@IBOutlet weak var tiltingView: TopTiltingView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		initUI()
		initEvents()
	}
	
	override func viewDidAppear(_ animated: Bool) {
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
		loginButton.rx.controlEvent([.touchDown]).bind {
			self.loginButton.backgroundColor = self.loginButton.tintColor
			}.disposed(by: disposeBag)
		
		loginButton.rx.controlEvent([.touchUpInside, .touchUpOutside]).bind {
			self.loginButton.backgroundColor = UIColor.clear
			}.disposed(by: disposeBag)
		let userid = ""
        do {
            try self.openSmLogin()
        } catch let error as LoginError {
            error.cook(userid)
        } catch let error {
            
        }
        
		loginButton.rx.tap.bind {
			try? self.openSmLogin()
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

			var html: String = ""
			//var isFailed = false
			// web preload
			do {
				let path = Definitions.externURLs.authUri
				html = try String(contentsOf: path.asUrl!, encoding: String.Encoding.utf8)
			} catch {
				BSTFacade.ux.showToast(BSTFacade.localizable.error.loginFailedCode(-1))
				RunInNextMainThread {
					button.stopAnimation(animationStyle: .expand, completion: {
						self.loginButtonView.show()
					})
				}
				return
			}
			
			RunInNextMainThread {
				button.stopAnimation(animationStyle: .expand, completion: {
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
