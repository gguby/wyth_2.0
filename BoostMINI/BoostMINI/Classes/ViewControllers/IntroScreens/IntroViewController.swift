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
	override func viewDidLoad() {
		IntroViewController.actual = self
        super.viewDidLoad()
        checkVersion()
    }
	
	deinit {
		IntroViewController.actual = nil
	}

	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension IntroViewController {
	
	
	private func checkVersion() {
		
		DefaultAPI.getVersionUsingGET { [weak self] body, err in
			
			if let bstError = err as? BSTError {
				bstError.cook()
				return
			}
			
			guard let data = body else {
				///BSTFacade.localizable
				BSTFacade.ux.showConfirm(BSTFacade.localizable.login.agreement(), { [weak self] isOk in
					if isOk == true {
						// retry...
						RunInNextMainThread {
							self?.checkVersion()
						}
					}
				})
				return
			}
			
			
			if let force = data.forceUpdate, force == true {
				// NEED UPDATE
				self?.showUpdateAlert(forceUpdate: true)
				return
			}
			
			if let vv = data.version, vv > BSTApplication.shortVersion ?? "" {
				self?.showUpdateAlert(forceUpdate: false)
			}
			
			self?.versionConfirmed()
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
			RunInNextMainThread(withDelay: 2.0, {
				self.presentHome()
			})
		} else {
			// 비로그인 유저
			self.presentLogin()
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
