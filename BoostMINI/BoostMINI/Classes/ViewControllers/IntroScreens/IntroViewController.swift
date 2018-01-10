//
//  IntroViewController.swift
//  BoostMINI
//
//  Created by Jack on 21/12/2017.
// Copyright © 2017 IRIVER LIMITED. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
	static var actual: IntroViewController? = nil

	@IBOutlet weak var loadingMarkRightGapWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var loadingMarkFrame: UIView!
	@IBOutlet weak var loadingMark: UIView!

	
	var progressCompleted: Bool = false
	var progressAnimationWaiting: Bool = true
	let progressStep1: CGFloat = 0.5
	let progressStep2: CGFloat = 0.7
	let progressStep3: CGFloat = 0.85
	let progressStep4: CGFloat = 1.0

	override func viewDidLoad() {
		IntroViewController.actual = self
        super.viewDidLoad()


		
    }
	
	deinit {
		IntroViewController.actual = nil
	}

	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		
		if progressAnimationWaiting{
			progressAnimationWaiting = false
			
			self.startLoadingMarkAnimation(progressStep1, duration:1.0)
		}
		
		
		//무조건?!
		if not(progressCompleted) {
			self.checkVersion()
		}
		

	}
	
	
	
}

extension IntroViewController {
	
	func startLoadingMarkAnimation(_ to: CGFloat, duration: TimeInterval = 1.5, animated: Bool = true, completed: ((Bool) -> Swift.Void)? = nil ) {
		//let val = min(max(0, to), loadingMark.frame.size.width + 20)
		let to2 = 1.0 - min(max(0.0, to), 1.0)
		let val = min(max(0.0, self.view.frame.size.width * to2), self.view.frame.size.width * 1.0)

		logVerbose("startLoadingMarkAnimation - to:\(to)[val:\(val)], duration:\(duration), anim:\(animated) / curr:\(self.loadingMarkRightGapWidthConstraint.constant)")

		
		if not(animated) {
			self.loadingMarkRightGapWidthConstraint.constant = val
			self.view.layoutIfNeeded()
			completed?(true)
			return
		}
		//loadingMarkFrameWidthConstraint.multiplier = 0
		//self.loginButtonBottomConstraint.constant = -self.loginButton.frame.height
		
		

		logVerbose("state : \(self.view.frame.width) - \(self.loadingMarkFrame.frame.width) : \(self.loadingMarkRightGapWidthConstraint.constant)")
		
		
		if self.loadingMarkRightGapWidthConstraint.constant == val {
			logVerbose("did")
			completed?(true)
			return
		}
		
		//self.loadingMarkFrame.layer.removeAllAnimations()
		self.loadingMarkRightGapWidthConstraint.constant = val

		
		UIView.animate(withDuration: duration,
					   animations: {
						self.view.layoutIfNeeded()
		}) { fin in
			logVerbose("startLoadingMarkAnimation[\(to),\(val),\(duration)] - FIN = \(fin)")
		}
		// constraint를 사용하면 animate completion 타이밍이 안맞는다.
		RunInNextMainThread(withDelay: duration) {
			logVerbose("startLoadingMarkAnimation[\(to),\(val),\(duration)] - FIN REAL %@".format(completed == nil ? "" : "closure"))
			completed?(true)

		}

	}
	
}

extension IntroViewController {
	private func checkVersion() {
		DefaultAPI.getVersionUsingGET { [weak self] body, err in
			
			if let bstError = err as? BSTError {
				bstError.cook()
				
				self?.startLoadingMarkAnimation(0.0)
				return
			}
			
			guard let data = body else {
				///BSTFacade.localizable
				BSTFacade.ux.showConfirm(BSTFacade.localizable.login.agreement(), { [weak self] isOk in
					if isOk == true {
						// retry...
						RunInNextMainThread {
							if let this = self {
								this.startLoadingMarkAnimation(0.0, duration: 0.0, animated: false)
								this.startLoadingMarkAnimation(this.progressStep1)
								this.checkVersion()
							}
						}
						return
					}
				})
				
				// blockMe()??
				return
			}
			
			if let vv = data.version, vv > BSTApplication.shortVersion ?? "" {
				self?.showUpdateAlert(forceUpdate: data.forceUpdate ?? false)
				return
			}

			RunInNextMainThread {
				guard let this = self else {
					return
				}
				
				this.startLoadingMarkAnimation(this.progressStep2, duration: 0.75, animated: true, completed: { fin in
					logVerbose("step2 fin. call versionConfirmed")
					this.versionConfirmed()
				})
			}
		}
	}
		
	
	func showUpdateAlert(forceUpdate: Bool = false) {
		BSTFacade.ux
			.showAlert( BSTFacade.localizable.alert.updateMessage(),
					   title: BSTFacade.localizable.alert.updateTitle(),
					   buttons: forceUpdate ? [.appStore] : [.appStore, .cancel] ) { [weak self] buttonIndex in
						guard let this = self else {
							return
						}
						
						if buttonIndex == 0 {
							OPEN_SAFARI(Definitions.externURLs.appstore)
						}
						if forceUpdate {
							this.blockMe()
						}
		}
	}
	
	func blockMe() {
		// block 해야될라낭?
		self.view.isUserInteractionEnabled = false	//??
	}
	
	
	func versionConfirmed() {
		// 버전이 옳다면 여기로 와준다.
		// 그렇다면 로그인 여부를 확인한다.
		logVerbose("Loginned? = \(SessionHandler.shared.isLoginned)")
		
		
		// TODO : 로그인이 유효한지의 여부를 서버로부터 확인해야 하면 여기에 추가한다.

		if SessionHandler.shared.isLoginned {
			// 로그인 유저
			self.startLoadingMarkAnimation(self.progressStep4, duration: 0.2, animated: true, completed: { fin in
				self.presentHome()
			})
		} else {
			// 비로그인 유저
			
			self.startLoadingMarkAnimation(self.progressStep4, duration: 0.8, animated: true, completed: { fin in
				self.presentLogin()
			})
		}
	}
	

	
	func presentHome() {
		guard let vc = R.storyboard.home().instantiateInitialViewController() else {
			BSTFacade.ux.showToast(BSTFacade.localizable.error.viewControllerMissing("Home.initialViewController"))
			return
		}
		self.present(vc, animated: false, completion: {
		})
	}
	
	func presentLogin() {
		guard let vc = R.storyboard.signUp().instantiateInitialViewController() else {
			BSTFacade.ux.showToast(BSTFacade.localizable.error.viewControllerMissing("SignUp.initialViewController"))
			return
		}
		self.present(vc, animated: false, completion: {
		})
	}
	
	
}
