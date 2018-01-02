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


	/// 공용 액션(클로져)
	open class Actions: NSObject {
		public typealias emptyAction = () -> Void
		
		public typealias boolAction = (Bool) -> Void
		public typealias intAction  = (Int) -> Void
		public typealias anyAction  = (Any) -> Void
		
		public typealias boolOptionalAction = (Bool?) -> Void
		public typealias intOptionalAction  = (Int?) -> Void
		public typealias anyOptionalAction  = (Any?) -> Void

	}
    // MARK: * IBOutlets --------------------

    // MARK: * Initialize --------------------

    init() {
    }

    // MARK: * Main Logic --------------------
	
	
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


	/// 알럿창을 띄운다.
	///
	/// - Parameters:
	///   - message: 메시지
	///   - completion: 알럿창을 닫으면 호출됨.
	///
	open func showAlert(_ message: String, _ completion: @escaping Actions.emptyAction = { }) {
		SystemAlert.show(nil, message: message, buttons: [AlertButtons.ok]) { fin in
			completion()
		}
    }
	
	/// 알럿창을 ok, cancel로 띄운다.
	///
	/// - Parameters:
	///   - message: 메시지
	///   - completion: 알럿창을 닫으면 호출될 클로져 블록. (true = ok, cancel = false 가 반환되고, 기타 알 수 없는 상황에서는 nil이 반환될 수 있음.
	open func showConfirm(_ message: String, _ completion: @escaping Actions.boolOptionalAction = { _ in }) {
		SystemAlert.show(nil, message: message, buttons: [.ok, .cancel]) { index in
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
						_ completion: @escaping Actions.intAction) {
		SystemAlert
			.show(title, message: message, buttons: buttons, completion: { index in
				completion(index)
			})
	}

	
	
	open func showAlert(_ message: String? = nil,
						title: String? = nil,
						buttons: AlertButtonSet,
						completions: [Actions.emptyAction]) {
		SystemAlert
			.show(title, message: message, buttons: buttons, completion: { index in
				
				let block = completions[safe: index]
				block?()
			})
	}

	
}

extension BSTUXHanlder {
}
