//
//
//  SystemAlert.swift
//  Lysn
//
//  Created by Retiree on 10/01/2017.
//  Copyright © 2017 SM Mobile Communications. All rights reserved.
//

import UIKit

let kAlertWindowLevel = (UIWindowLevelAlert + 1)

class SystemAlertViewController: UIViewController {
	var presentedStatusBarStyle = UIStatusBarStyle(rawValue: 0)!
	// 현재스타일로 함께 사용.
	var isStatusBarHidden = false
	
	init(statusBarStyle: UIStatusBarStyle) {
		super.init(nibName: nil, bundle: nil)
		presentedStatusBarStyle = statusBarStyle
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func loadView() {
		super.loadView()
		//    _presentedStatusBarStyle = [UIApplication sharedApplication].statusBarStyle
		
	}
}

class SystemAlert: NSObject {

	class text { // TODO... 리소스나 언어사전 연동 필요.
		static let ok     = "확인"
		static let cancel = "취소"
	}
	
	class func show(_ sender: UIViewController?, title: String?, message: String?, buttons: [String]?, completion: ((_ buttonIndex: Int) -> Void)? = nil) {
		// TODO : 비디오 플레이어처럼 상태표시줄이 없어야 되는 경우는, 상태표시줄이 없는 알럿으로 띄워줘야함..
		var viewController: UIViewController?
		if sender == nil {
			let window = UIWindow(frame: UIScreen.main.bounds)
			window.rootViewController = SystemAlertViewController(statusBarStyle: UIApplication.shared.statusBarStyle)
			
			window.windowLevel = kAlertWindowLevel
			window.makeKeyAndVisible()
			viewController = window.rootViewController ?? UIViewController()
		}
		let tt: String = title ?? ""
		var mm: String = message ?? ""
		if tt.isEmpty && mm.isEmpty {
			// title, message 가 전부 없어서 버튼만 있고 메시지 부가 아예 없는 메시지 창을 막기 위해 처리.
			// title만 사용하는 경우, 메시지의 @" " 때문에 빈 줄이 생기던 기존 소스의 이슈를 재수정하였음.
			mm = " "
		}
		let alertView = UIAlertController(title: tt, message: mm, preferredStyle: .alert)
		var idx: Int = 0
		
		if let buttons = buttons {
			for btn: String in buttons {
				alertView.addAction(UIAlertAction(title: btn, style: .default, handler: {(_ action: UIAlertAction) -> Void in
					completion?(idx)
				}))
				idx += 1
			}
		}
		
		viewController?.present(alertView, animated: true)
		//alertView.view.tintColor = UIColor(hexString: "#313131")
	}
	
	class func show(_ title: String?, message: String?, buttons buttonArray: [String], completion: ((_ buttonIndex: Int) -> Void)?) {
		SystemAlert.show(nil,
						 title: title,
						 message: message,
						 buttons: buttonArray,
						 completion: {(_ buttonIndex: Int) -> Void in
							completion?(buttonIndex)
		})
	}
	
	class func show(_ title: String?, message: String?, ok okString: String?, cancel cancelString: String?, completion: ((_ ok: Bool) -> Void)?) {
		SystemAlert.show(nil,
						 title: title,
						 message: message,
						 buttons: [cancelString ?? SystemAlert.text.cancel, okString ?? SystemAlert.text.ok],
						 completion: {(_ buttonIndex: Int) -> Void in
							completion?(buttonIndex == 1)
		})
	}
	
	class func show(_ title: String?, message: String?, cancel cancelString: String?) {
		SystemAlert.show(nil, title: title, message: message, buttons: [cancelString ?? SystemAlert.text.cancel])
	}
	
	class func show(_ title: String?, message: String?, cancel cancelString: String?, completion: ((_ cancel: Bool) -> Void)?) {
		SystemAlert.show(nil, title: title, message: message, buttons: [cancelString ?? SystemAlert.text.cancel],
						 completion: {(_ buttonIndex: Int) -> Void in
							completion?(true)
		})
	}
	
	class func show(_ title: String?, message: String?) {
		SystemAlert.show(nil, title: title, message: message, buttons: [SystemAlert.text.ok])
	}
}
