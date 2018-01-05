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
		// 버전을 체크한다.
		AppVersionModel.get { block in

			// TODO: api 실패해도 우선 진행
			let block_isSucceed = true	//block.isSucceed
			if not(block_isSucceed) {
				let msg = "API test 1 : failed"
				logWarning(msg)
				BSTFacade.ux.showToast(msg)
				return
			}
			let data = block.data?.first
			
			logVerbose("AppVersionModel = \(String(describing: data))")
			
			let forceUpdate = data?.isForceUpdate ?? false
			let isNeedUpdate = data?.isNeedUpdate ?? false
			
			// TODO : 서버 응답없는 경우도 필요하다. 하지만 이는 네트워크 에러 핸들링에서 해주게 될 것이다.
			
			RunInNextMainThread {
				if isNeedUpdate {
					self.showUpdateAlert(forceUpdate: forceUpdate)
				} else {
					self.versionConfirmed()
				}
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
