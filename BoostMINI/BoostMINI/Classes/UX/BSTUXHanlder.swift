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
    
    // MARK: * properties --------------------
	fileprivate let toast = ToastManager()
	
	
    // MARK: * IBOutlets --------------------

    // MARK: * Initialize --------------------

    init() {
    }

    // MARK: * Main Logic --------------------
	func showToast(message: String) {
		
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
	func showToast(_ message: String,
			   delay: TimeInterval? = nil,
						delay: TimeInterval? = nil,
						duration: TimeInterval? = nil,
						clearStack: Bool = false) {
		ToastManager.clear()
		ToastManager.pop(message, delay: delay, duration: duration, clearStack:clearStack)
	}
	
	
    func showAlert(message: String) {
        SystemAlert.show(nil, message: message)
    }
    
    class func showConfirm(message: String) {
    }
    
    class func toast(message: String) {
        
    }
}

extension BSTUXHanlder {
}
