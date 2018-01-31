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
class LogInViewController: BoostUIViewController {

	@IBOutlet weak var loginButton: TransitionButton!
	@IBOutlet weak var testButton: TransitionButton?
	
	@IBOutlet weak var loginButtonView: UIView!
	@IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var loadingMarkFrameWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var loadingMarkFrame: UIView!
	@IBOutlet weak var loadingMark: UIView!
	
	@IBOutlet weak var loginLabel: UILabel!

	var cacheLoginButtonBottomConstraint: CGFloat!


	// 최초 1회 이후의 로그인 접근은 애니메이션 없음.
	public static var isFirst = true
	
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
		
		
		if LogInViewController.isFirst {
			LogInViewController.isFirst = false
			cacheLoginButtonBottomConstraint = self.loginButtonBottomConstraint.constant
			startPopLoginButton()
		} else {
			self.loginButton.isHidden = false
			self.loginButtonView.isHidden = false
		}
	}
	
	
	
	var disposeBag = DisposeBag()
	private func initUI() {
		loginLabel.text = BSTFacade.localizable.login.smLoginText()
		cacheLoginButtonBottomConstraint = loginButtonBottomConstraint.constant
	}

	
	func initEvents() {
		[loginButton, testButton].forEach { (bto: TransitionButton?) in
			guard let bt = bto else { return }
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
		
		
		if let testButton = testButton {
			testButton.rx.tap.bind {
				testButton.startAnimation()
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.666) { [weak self] in
					self?.testButton?.stopAnimation(animationStyle: .expand, completion: {
						self?.goHome()
					})
				}
				}.disposed(by: disposeBag)
		}
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
				//self.testButton?.show()
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
		
		loginButtonView.hide()
		let qualityOfServiceClass = DispatchQoS.QoSClass.background
		let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
		backgroundQueue.async(execute: {

			var isFailed = false
			DispatchQueue.main.async {
				self.loginButtonView.show()
				if isFailed {
					return
				}
				let newVC = R.storyboard.signUp.smLoginViewController()!
				self.navigationController?.pushViewController(newVC, animated: true)
			}
		})
	}
	
}
