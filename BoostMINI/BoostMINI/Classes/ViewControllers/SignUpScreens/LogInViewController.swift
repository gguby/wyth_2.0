//
//  LogInViewController.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 26..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import UIKit
//import RxCocoa
//import RxSwift
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
		navigationController?.isNavigationBarHidden = true
		navigationController?.hidesBarsOnTap = false

		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.666) { [weak self] in
				self?.testButton.stopAnimation(animationStyle: .expand, completion: {
					self?.goHome()
				})
			}
			}.disposed(by: disposeBag)
		
	}
	
	
}

extension LogInViewController {
	
	func startPopLoginButton() {
		logVerbose("startPopLoginButton")
		self.loginButtonBottomConstraint.constant = -self.loginButton.frame.height
		self.view.layoutIfNeeded()
		
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			self.loginButtonBottomConstraint.constant = self.cacheLoginButtonBottomConstraint
			
			self.loginButton.isHidden = false
			self.loginButtonView.isHidden = false
			
			UIView.animate(withDuration: 0.8,
						   animations: {
							self.view.layoutIfNeeded()
			}) { fin in
				logVerbose("startPopLoginButton")
				if !(fin) {
					return
				}
				self.testButton.show()
			}
		}
	}
}

extension LogInViewController {
	
	func goHome() {
		logVerbose("go home")
		BSTFacade.go.home(self, animated: false)
	}

	
	func openSmLogin() {
		
		logVerbose("sm login")
		
		guard let button = self.loginButton else {
            let error = BSTError.login(LoginError.failedCode(-2))
			error.cook(nil)
//            BSTFacade.ux.showToastError(BSTFacade.localizable.error.loginFailedCode(-2))
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
				BSTFacade.ux.showToastError(BSTFacade.localizable.error.loginFailedCode(-1))
				isFailed = true
			}
			
			DispatchQueue.main.async {
//				button.stopAnimation(animationStyle: .expand, completion: {
					self.loginButtonView.show()
					if isFailed {
						return
					}
					
					let newVC = SMLoginViewController.create("SignUp")
					//let newVC = R.storyboard.signUp.smLoginViewController()!
					if !(html.isEmpty) {
						//newVC.preload = html
					}
					self.navigationController?.pushViewController(newVC, animated: true)
//				})
			}
		})
	}
	
}
