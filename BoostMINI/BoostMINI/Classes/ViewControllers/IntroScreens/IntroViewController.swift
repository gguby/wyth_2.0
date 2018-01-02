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


class IntroViewController: UIViewController {

    // MARK: * properties --------------------

    // MARK: * IBOutlets --------------------

    // MARK: * Initialize --------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        checkVersion()
        initProperties()
        initUI()
        prepareViewDidLoad()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		// TestModel 을 가져온다.
		APIService<TestModel>.get { block in
			if not(block.isSucceed) {
				let msg = "API test 1 : failed"
				logWarning(msg)
				BSTFacade.ux.showToast(msg)
				return
			}
			// 테스트용 텍스트로 변환...
			let userInfo = "API test 1 : " + (block.data!.flatMap { "\($0.description)" }).joined(separator: ",\r")
			logInfo(userInfo)
			BSTFacade.ux.showToast(userInfo)
		}
	}

    private func checkVersion() {

        // TODO: 버전을 체크한다.
		APIService<AppVersionModel>.get { block in
			if not(block.isSucceed) {
				let msg = "API test 1 : failed"
				logWarning(msg)
				BSTFacade.ux.showToast(msg)
				return
			}
			// 테스트용 텍스트로 변환...
			let userInfo = "API test 1 : " + (block.data!.flatMap { "\($0.description)" }).joined(separator: ",\r")
			logInfo(userInfo)
			BSTFacade.ux.showToast(userInfo)
		}


        // DUMMY CODE
        let forceUpdate = false // 강제업데이트 여부.
		
		RunInNextMainThread(withDelay: 1.0, {
			// TODO: 구버전인가의 여부
            let isOldVersion = (arc4random() % 100) == 1	// 100분의 1 확률로 뜸... -ㅁ-

            if isOldVersion {
				self.showUpdateAlert(forceUpdate: forceUpdate)
				return
			}
			
		})
	}

    private func initProperties() {
    }

    private func initUI() {
    }

    func prepareViewDidLoad() {
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
							RunInNextMainThread {
								this.openAppStore()
							}
						}
						if forceUpdate {
							this.blockMe()
						}
		}
	}

    func openAppStore() {
        OPEN_SAFARI(Definitions.externURLs.appstore)
    }
	
	func blockMe() {
		self.view.isUserInteractionEnabled = false	//??
	}

	fileprivate var rotate = 0
    // MARK: * UI Events --------------------
	@IBAction func test1ButtonTouched(_ sender: Any) {
		// alert test
		rotate += 1

		if rotate == 2 {
			rotate = 0
			BSTFacade.ux
				.showAlert("ALERT를 띄웁니다.".locale,
						   buttons: [.ok, .cancel]) { index in
							switch(index) {
							case 0:	// ok
								BSTFacade.ux.showToast("index:\(index) - Ok가 눌림", clearStack: true)
							case 1: // cancel
								BSTFacade.ux.showToast("index:\(index) - Cancel 이 눌림", clearStack: true)
							default:	// not used
								BSTFacade.ux.showToast("index:\(index) - 안눌림.. (버그)", clearStack: true)
							}
			}
		} else {
			BSTFacade.ux.showAlert("ALERT를 띄웁니다.".locale)
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
