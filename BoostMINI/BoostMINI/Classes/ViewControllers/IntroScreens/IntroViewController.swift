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



/// 동일뷰에서 모두 처리하는것도 방법이지만
/// 일단은 여기에서 로그인이 필요한지 홈이 필요한지에 따라
/// 해당 뷰로 애니메이션 없이 바로 이동해주도록 한다.
/// 동일한 초기화면이어야 한다.
/// 추후 변경 가능.

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkVersion()
    }
	
	
	private func checkVersion() {
		// 버전을 체크한다.
		APIService<AppVersionModel>.get { block in

			// TODO: api 실패해도 우선 진행
			let block_isSucceed = true	//block.isSucceed
			if not(block_isSucceed) {
				let msg = "API test 1 : failed"
				logWarning(msg)
				BSTFacade.ux.showToast(msg)
				return
			}
			let data = block.data?.first	// guard로 변경필요. isSucceed면 data는 항상 있어야 정상임.
			
			
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


    // MARK: * Main Logic --------------------

    /// 업데이트 알럿 메시지 뿌리기.
    ///
    /// - Parameter forceUpdate: 강제로 업데이트해야하는경우의 여부
    func showUpdateAlert(forceUpdate: Bool = false) {

		BSTFacade.ux
			.showAlert("지금 업데이트하여 새로운 버전의 Boost 서비스를 이용하세요.".locale,
					   title: "최신버전으로 업데이트".locale,
					   buttons: forceUpdate ? [.ok] : [.ok, .cancel] ) { [weak self] buttonIndex in
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
		logVerbose("")
		if SessionHandler.sharedInstance.isLoginned {
		
		}
		
	}

	fileprivate var rotate = 0
    // MARK: * UI Events --------------------
	@IBAction func test1ButtonTouched(_ sender: Any) {
		
		// alert test
		rotate += 1

		if rotate == 2 {
			rotate = 0
			BSTFacade.ux
				.showAlert("ALERT을 띄웁니다.".locale,
						   buttons: [.ok, .cancel]) { index in
							switch(index) {
							case 0:	// ok
								BSTFacade.ux.showToast("index:\(index) - %@".format(" - Ok가 눌림".locale), clearStack: true)
							case 1: // cancel
								BSTFacade.ux.showToast("index:\(index) - %@".format("Cancel 이 눌림".locale), clearStack: true)
							default:	// not used
								BSTFacade.ux.showToast("index:\(index) - %@".format("안눌림.. (버그)".locale), clearStack: true)
							}
			}
		} else {
			BSTFacade.ux.showAlert("ALERT을 띄웁니다.".locale)
		}
	}

	
	@IBAction func test2ButtonTouched(_ sender: Any) {
		// toast test
		struct Holder {
			static var no: Int = -1
		}
		let sample = ["토스트는 맛있습니다.",
					  "맛있는건 바나나",
					  "바나나는 빨개...??!",
					  "빠빠빠 빨간 맛!"]
		Holder.no += 1
		Holder.no = Holder.no % sample.count
		
		BSTFacade.ux.showToast(sample[safe: Holder.no]!.locale)


	}
	
	
	// MARK: * Memory Manage --------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension IntroViewController {
}
