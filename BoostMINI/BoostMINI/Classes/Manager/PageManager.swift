//
//  PageManager.swift
//  BoostMINI
//
//  호출하는 뷰컨트롤러의 위치 또는 인트로의 구조 등등에 의해 동작이 잘 안되거나 이상할 수 있으니 진행하면서 수정 요망.
//  현재는 IntroVC가 항상 있고 거기에 임의의 뷰가 present 되는 구조.
//
//  Created by jack on 2018. 1. 11..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit

extension BST {
	class PageManager {
		// Window - Intro - present something...
		static let shared = PageManager()
	
		/// 홈 화면으로 이동
		///
		/// - Parameters:
		///   - currentVC: 현재 뷰 컨트롤러
		///   - animated: 애니메이션 여부
		func home(_ currentVC: UIViewController? = nil, animated: Bool = false) {
			// 메인으로이동.
			guard let vc = R.storyboard.home().instantiateInitialViewController() else {
				BSTError.debugUI(.storyboard("Home.initialViewController"))
					.cookError()
				return
			}
			processTopPresent(currentVC, to: vc, animated: animated)
		}

		
		func login(_ currentVC: UIViewController? = nil, animated: Bool = false) {
			guard let vc = R.storyboard.signUp().instantiateInitialViewController() else {
				BSTError.debugUI(.storyboard("SignUp.initialViewController"))
					.cookError()
				return
			}
			if animated {
				// 애니메이션 재 활성화. AgreementViewController에서 호출시에는 animated가 false 이므로, 이 경우만 무시.
				LogInViewController.isFirst = true
			}
			processTopPresent(currentVC, to: vc, animated: animated)
		}
        
        func device(_ currentVC : UIViewController? = nil, type : ReactorViewType) {
            guard let vc = BSTFacade.ux.instantiateViewController(typeof: BTDeviceViewController.self) else {
                return
            }
            let reactor = DeviceViewReactor.init(service: BTDeviceService.init())
            reactor.viewType = type
            vc.reactor = reactor
            
            guard let currentVC = currentVC ?? BSTFacade.common.getTopViewController() else {
                BSTError.debugUI(.viewController("getCurrentTopVC"))
                    .cookError()
                return
            }
            
            currentVC.navigationController?.pushViewController(vc, animated: true)
        }
		
		
		func removeAllUx() {
			BSTFacade.ux.hideIndicator()
			
		}
		
		private func processTopPresent(_ current: UIViewController?, to target: UIViewController, animated: Bool) {
			guard let currentVC = current ?? BSTFacade.common.getTopViewController() else {
				BSTError.debugUI(.viewController("getCurrentTopVC"))
					.cookError()
				return
			}

			guard let top = IntroViewController.actual else {
				BSTError.debugUI(.viewController("IntroViewController.actual"))
					.cookError()
				return
			}
			

			top.blur()
			let block = {
				self.removeAllUx()
				top.present(target, animated: false, completion: {
				})
			}
			removeAllUx()

			if currentVC == top {
				block()
				return
			}
			
			currentVC.dismiss(animated: animated) {
				block()
			}
		}
	}
}

