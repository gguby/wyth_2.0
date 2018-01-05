//
//  IntroViewController.swift
//  BoostMINI
//
//  Created by Jack on 21/12/2017.
// Copyright © 2017 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit
import ReactorKit
import RxCocoa
import RxSwift




/// 여기는 대부분 지울 코드들이다.. 흠.

class IntroViewController: UIViewController {

	@IBOutlet weak var tiltingView: TopTiltingView!
	@IBOutlet var tilts: [TopTiltingView]!

	@IBOutlet weak var slider: UISlider!
	@IBOutlet weak var testView: UIView!

	@IBOutlet weak var goHome:  UIButton!
	@IBOutlet weak var goLogin: UIButton!
	var disposeBag = DisposeBag()

	
	
	var isDebugMode = false
	
	override func viewDidLoad() {
        super.viewDidLoad()
        checkVersion()
		slider.minimumValue = -100
		slider.maximumValue = 100
	
		var toggle = false
		for view in tilts {
			toggle = !toggle
			view.useCenter = toggle
		}
		tiltingView.useCenter = true
		
		
		
		goHome.rx.tap.subscribe() { event in
			self.presentHome()
			}.disposed(by: disposeBag)
		goLogin.rx.tap.subscribe() { event in
			self.presentLogin()
			}.disposed(by: disposeBag)

    }

	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func sliderChanged(_ sender: Any) {
		isDebugMode = true

		let val = self.slider.value.c
		for view in tilts {
			view.updateDisplayTiltMask(val)
		}

	}
	
	@IBAction func testButtonTouched(_ sender: Any) {
	
		isDebugMode = true
		
		// -100 ~ 100
		let newVal: CGFloat = (arc4random() % 200) - 100
		for view in tilts {
			view.updateDisplayTiltMask(newVal, animation: true)
		}
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
			
			// TODO : 서버 응답없는 경우도 필요하다. 이는 네트워크 에러 핸들링에서 해주게 될 것이다.
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
		
		if SessionHandler.shared.isLoginned {
			// 로그인 유저
			RunInNextMainThread(withDelay: 2.0, {
				if self.isDebugMode {
					self.testView.isHidden = false
					return
				}
				self.presentHome()
			})
			
		} else {
			// 비로그인 유저
			self.presentLogin()
		}
	}

	
	func presentHome() {
		let storyboard = UIStoryboard(name: "Home", bundle: nil)
		let vc = storyboard.instantiateInitialViewController()!	// HomeViewController의 상위 NavigationViewController 이다.
		self.present(vc, animated: false, completion: {
		})
	}
	
	func presentLogin() {
		let vc = LogInViewController.create("SignUp")
		self.present(vc, animated: false, completion: {
		})
	}
	
	
}
