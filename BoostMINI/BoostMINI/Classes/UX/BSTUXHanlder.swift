//
//  BSTUXHanlder
//  BoostMINI
//
//  Created by HS Lee on 21/12/2017.
//  Copyright © 2017 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit

class BSTUXHandlerInstance {
    var view: UIView?
}


class BSTUXHanlder {
    
    // MARK: - * properties --------------------
	fileprivate let toast = ToastManager()
    
    // MARK: - * IBOutlets --------------------

    // MARK: - * Initialize --------------------

    init() {
    }

    // MARK: - * Main Logic --------------------
    
    
    
    /// HelpWebViewController로 go
    ///
    /// - Parameter currentVC: 현재 ViewController
    func goHelpWebViewController(currentViewController currentVC: UIViewController?) {
        guard let vc = self.instantiateViewController(typeof: HelpWebViewController.self) else {
            return
        }
        
        if let nc = currentVC?.navigationController {
            currentVC?.navigationController?.pushViewController(vc, animated: true)
        } else {
            currentVC?.present(vc, animated: true, completion: nil)
        }
    }
    
    func goTicketScan(currentViewController currentVC: UIViewController?) {
        guard let vc = self.instantiateViewController(typeof: TicketScanViewController.self) else {
            return
        }
        
        currentVC?.present(vc, animated: true, completion: nil)
    }
    
    func goDetailConcertInfoViewController(currentViewController currentVC: UIViewController?) {
        guard let vc = self.instantiateViewController(typeof: DetailConcertInformationViewController.self) else {
            return
        }
        
        currentVC?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goSettingViewController(currentViewController currentVC: UIViewController?) {
        guard let vc = self.instantiateViewController(typeof: SettingViewController.self) else {
            return
        }
        
        currentVC?.navigationController?.pushViewController(vc, animated: true)
    }
    
    ///알림 목록 화면을 로딩함.
    func goNotification() {
        guard let vc = self.instantiateViewController(typeof: NotificationViewController.self) else {
            return
        }
        
        if let topVC = CommonUtil.getTopVisibleViewController() {
            FuncHouse.dispatchAfter(duration: 1.0, fn: {
                topVC.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }
    
    func goDevice(_ currentVC : UIViewController? = nil, type : ReactorViewType) {
        guard let vc = self.instantiateViewController(typeof: BTDeviceViewController.self) else {
            return
        }
        let reactor = DeviceViewReactor.init(service: BTDeviceService.init())
        reactor.viewType = type
        vc.reactor = reactor
        
        guard let currentVC = currentVC else {
            BSTError.debugUI(.viewController("getCurrentTopVC"))
                .cookError()
            return
        }
        
        guard let navi = currentVC.navigationController else {
            currentVC.present(vc, animated: true, completion: nil)
            return
        }
        
        navi.pushViewController(vc, animated: true)
    }
    
    // MARK: - * Common 함수 --------------------
    
    /// ViewController 타입으로 사전(Storyboard)에 정의된 ViewController를 반환
    ///
    /// - Parameter typeof: T - destination ViewController
    /// - Returns: T - UIViewController
    func instantiateViewController<T: UIViewController>(typeof: T.Type) -> T? {
        let className = String(describing: typeof)
        guard let viewController = BSTScreens.instantiate(withClassName: className) else {
            fatalError("\(className) not found.")
        }
        return viewController as? T
    }
    
	/// 토스트를 띄운다.
	///
	/// - Usage:
	///	  - simple:
	///   		BSTFacade.ux.showToast("토스트")
	///   - complex:
	///     	BSTFacade.ux.showToast("토스트", delay: 0.5, duration: 3)
	///   - complex2:
	///     	BSTFacade.ux.showToast("토스트", delay: 0.5, duration: 3, clearStack: true)
	///
	/// - Parameters:
	///   - message: 메시지
	///   - delay: 메시지 뜨기 전 지연시간 (생략시 기본값)
	///   - duration: 노출시간 (생략시 기본값)
	///   - clearStack: 현재 화면에 떠있는 토스트 및 대기중인 토스트 목록을 싹 다 제거하고, 이 토스트를 바로 띄워준다. (기본값 false)
	open func showToast(_ message: String,
				   delay: TimeInterval? = nil,
				   duration: TimeInterval? = nil,
				   clearStack: Bool = false) {
		ToastManager.pop(message, delay: delay, duration: duration, clearStack:clearStack)
	}

	/// 에러스타일 토스트를 띄운다.
	///
	/// - Parameter message: 메시지
	open func showToastError(_ message: String) {
		logError("ERROR!: \(message)")
		ToastManager.popError(message)
	}


	/// 알럿창을 띄운다.
	///
	/// - Parameters:
	///   - message: 메시지
	///   - completion: 알럿창을 닫으면 호출됨.
	///
	open func showAlert(_ message: String, _ completion: @escaping BSTClosure.emptyAction = { }) {
		SystemAlert.show(nil, message: message, buttons: [AlertButtons.ok]) { fin in
			completion()
		}
    }
	
	/// 알럿창을 ok, cancel로 띄운다.
	///
	/// - Parameters:
	///   - message: 메시지
	///   - completion: 알럿창을 닫으면 호출될 클로져 블록. (true = ok, cancel = false 가 반환되고, 기타 알 수 없는 상황에서는 nil이 반환될 수 있음.
    open func showConfirm(_ message: String, title: String? = nil, _ completion: @escaping BSTClosure.boolOptionalAction = { _ in }) {
		SystemAlert.show(title, message: message, buttons: [.ok, .cancel]) { index in
			switch(index) {
			case 0:
				completion(true)
			case 1:
				completion(false)
			default:
				completion(nil)
			}
		}
	}

	
	
	/// 알럿창을 띄운다.
	///
	///
	/// - Parameters:
	///   - message: 메시지
	///   - title: 타이틀이 필요하다면 타이틀
	///   - buttons: 버튼 목록. 우측부터 순서대로 노출됨
	///   - completion: 알럿창을 닫으면 호출될 클로져 블록.  누른 버튼의 인덱스가 반환된다. 우측부터 순서대로 0, 1, 2 ...
	open func showAlert(_ message: String,
						title: String? = nil,
						buttons: AlertButtonSet = [.ok],
						_ completion: @escaping BSTClosure.intAction = { _ in }) {
		SystemAlert
			.show(title, message: message, buttons: buttons, completion: { index in
				completion(index)
			})
	}

	
	
	open func showAlert(_ message: String? = nil,
						title: String? = nil,
						buttons: AlertButtonSet,
						completions: [BSTClosure.emptyAction]) {
		SystemAlert
			.show(title, message: message, buttons: buttons, completion: { index in
				
				if let block = completions[safe: index] {
					block()
				}
			})
	}
	
	
	
	
	
	/// 인디게이터를 보여준다.
	///
	/// - Parameter info: 인디게이터를 띄운 쪽의 정보. 보통은 생략하면 된다.
	///                   특별히 codegenRestAPI.sh 에서 만들어진 코드에서는 "codegenRestAPI" 가 들어오게 된다.
	open func showIndicator(_ info: String? = nil) {
//		logVerbose("\(#function) \(info)")
//		if info == "codegenDK-DefaultAPI" {
//			return
//		}
		DispatchQueue.main.async {
			LoadingIndicator.show(message: info)
		}
		
	}
	
	/// 인디게이터를 숨긴다.
	///
	/// - Parameter info: 인디게이터를 띄운 쪽의 정보. 보통은 생략하면 된다.
	open func hideIndicator(_ info: String? = nil) {
//		logVerbose("\(#function) \(info)")
//		if info == "codegenDK-DefaultAPI" {
//			return
//		}
		DispatchQueue.main.async {
			LoadingIndicator.hide(animate: true, message: info)
		}
	}
	

}

extension BSTUXHanlder {
}
