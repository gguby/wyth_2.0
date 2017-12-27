//
//  MainViewController.swift
//  BoostMINI
//
//  Created by HS Lee on 21/12/2017.
// Copyright © 2017 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {

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

    private func checkVersion() {

        // TODO: 버전을 체크한다.

        // DUMMY CODE
        let forceUpdate = false // 강제업데이트 여부.
		
		RunInNextMainThread(withDelay: 1.0, {
            // 구버전인가의 여부
            var isOldVersion = false

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

        SystemAlert
            .show(_T("최신버전으로 업데이트"),
                  message: _T("지금 업데이트하여 새로운 버전의 Boost 서비스를 이용하세요."),
                  buttons: [_T("Ok"), _T("Cancel")]
            ) {
                [weak self] buttonIndex in
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
        OPEN_SAFARI(Definitions.path.appstore)
    }
	
	func blockMe() {
		self.view.isUserInteractionEnabled = false	//??
	}

    // MARK: * UI Events --------------------

    // MARK: * Memory Manage --------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MainViewController {
}
