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
	@IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
	//@IBOutlet weak var tiltingView: TopTiltingView!
	@IBOutlet weak var loadingMarkFrameWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var loadingMarkFrame: UIView!
	@IBOutlet weak var loadingMark: UIView!
	
	@IBOutlet weak var loginLabel: UILabel!

	var cacheLoginButtonBottomConstraint: CGFloat!


	var isFirst = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		loginButton.isHidden = true
		loginButtonView.isHidden = true
		
		initUI()
		initEvents()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	override func viewDidAppear(_ animated: Bool) {
		self.navigationController?.isNavigationBarHidden = true
		super.viewDidAppear(animated)
		
		
		if isFirst {
			isFirst = false
			cacheLoginButtonBottomConstraint = self.loginButtonBottomConstraint.constant
			startPopLoginButton()
		}
	}
	
	
	
	var disposeBag = DisposeBag()
	private func initUI() {
		loginLabel.text = BSTFacade.localizable.login.smLoginText()
		cacheLoginButtonBottomConstraint = loginButtonBottomConstraint.constant
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
		
		
		loginButton.rx.tap.bind {
			self.openSmLogin()
			}.disposed(by: disposeBag)
		
		
		testButton.rx.tap.bind {
			self.testButton.startAnimation()
			FunctionHouse.runInNextMainThread(withDelay: 0.666, { [weak self] in
				self?.testButton.stopAnimation(animationStyle: .expand, completion: {
					self?.goHome()
				})
			})
			}.disposed(by: disposeBag)
	}
	
	
}

extension LogInViewController {
	
	func startPopLoginButton() {
		logVerbose("startPopLoginButton")
		self.loginButtonBottomConstraint.constant = -self.loginButton.frame.height
		self.view.layoutIfNeeded()
		
		FunctionHouse.runInNextMainThread(withDelay: 0.1, {
			self.loginButtonBottomConstraint.constant = self.cacheLoginButtonBottomConstraint
			
			self.loginButton.isHidden = false
			self.loginButtonView.isHidden = false
			
			UIView.animate(withDuration: 0.8,
						   animations: {
							self.view.layoutIfNeeded()
			}) { fin in
				logVerbose("startPopLoginButton")
				if FunctionHouse.not(fin) {
					return
				}
				self.testButton.show()
			}
		})
	}
}

extension LogInViewController {
	
	func goHome() {
		logVerbose("go home")

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

	
	func openSmLogin() {
		
		logVerbose("sm login")
		
		guard let button = self.loginButton else {
            let error = BSTError.login(LoginError.failedCode(-2))
			error.cook(nil)
//            BSTFacade.ux.showToast(BSTFacade.localizable.error.loginFailedCode(-2))
			return
		}

		
		
		
		loginButtonView.hide()
//		button.startAnimation()
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
			
			FunctionHouse.runInNextMainThread {
//				button.stopAnimation(animationStyle: .expand, completion: {
					self.loginButtonView.show()
					if isFailed {
						return
					}
					
					let newVC = SMLoginViewController.create("SignUp")
					//let newVC = R.storyboard.signUp.smLoginViewController()!
					if FunctionHouse.not(html.isEmpty) {
						//newVC.preload = html
					}
					self.navigationController?.pushViewController(newVC, animated: true)
//				})
			}
		})
	}
	
}
