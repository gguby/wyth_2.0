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


public enum AlertButtons: String {
	case ok
	case cancel
	//case ignore
	case yes
	case no
	case like
	case prev
	case next
	case appStore

	public var text: String {
		let map: [AlertButtons: String] = [
			.ok       : BSTFacade.localizable.alert.ok(),		// "확인",
			.cancel   : BSTFacade.localizable.alert.cancel(),	// "취소",
			//.ignore : BSTFacade.localizable.alert.ignore(),	// "무시",
			.yes      : BSTFacade.localizable.alert.yes(),		// "예",
			.no       : BSTFacade.localizable.alert.no(),		// "아니오",
			.like     : BSTFacade.localizable.alert.like(),		// "좋아요",
			.prev     : BSTFacade.localizable.alert.prev(),		// "이전",
			.next     : BSTFacade.localizable.alert.next(),		// "다음"
			.appStore : BSTFacade.localizable.alert.appStore()	// "앱스토어로 이동"
		]
		
		return map[self] ?? "\(self)"
	}
}

public typealias AlertButtonSet = [AlertButtons]



// 외부에서 바로 호출못하도록 BSTUXHanlder 내부에 생성
extension BSTUXHanlder {


	
	internal class SystemAlertViewController: UIViewController {
		var presentedStatusBarStyle = UIStatusBarStyle.lightContent
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

	

	
	
	internal class SystemAlert {

		private static var stackVC: [UIAlertController] = []
		
		private static let privateInstance = SystemAlert()
		private init() { }
		private var window: UIWindow?
		
		class func show(_ sender: UIViewController?,
						title titleTemp: String?,
						message messageTemp: String?,
						buttonTexts: [String] = [AlertButtons.ok.text],
						completion: ((_ buttonIndex: Int) -> Void)? = nil) {
			
			// INFO: 비디오 플레이어처럼 상태표시줄이 없어야 되는 경우는, 상태표시줄이 없는 알럿으로 띄워줘야함..
			var viewController: UIViewController? = sender
			if sender == nil {
				
				if SystemAlert.privateInstance.window == nil {
					SystemAlert.privateInstance.window = UIWindow(frame: UIScreen.main.bounds)
					//SystemAlert.privateInstance.window?.backgroundColor = UIColor("#cccccccc")
				}
				guard let window = SystemAlert.privateInstance.window else {
					logError("alert window error - \(titleTemp ?? "")")
					return
				}
				
				window.frame = UIScreen.main.bounds

				window.rootViewController = SystemAlertViewController(statusBarStyle: UIApplication.shared.statusBarStyle)

				window.windowLevel = kAlertWindowLevel
				window.makeKeyAndVisible()
				window.isUserInteractionEnabled = true
				window.isHidden = false

				
				viewController = window.rootViewController ?? UIViewController()
			}
			let title: String = titleTemp ?? "" // _title
			var message: String = messageTemp ?? ""
			if title.isEmpty && message.isEmpty {
				// title, message 가 전부 없어서 버튼만 있고 메시지 부가 아예 없는 메시지 창을 막기 위해 처리.
				// title만 사용하는 경우, 메시지의 @" " 때문에 빈 줄이 생기던 기존 소스의 이슈를 재수정하였음.
				message = " "
			}
			let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
			var idx: Int = buttonTexts.count - 1	// zero based.

			// 역순으로 표시. (우측부터)
			for text in buttonTexts.reversed() {
				let index = idx
				alertView.addAction(UIAlertAction(title: text, style: .default, handler: { (_: UIAlertAction) -> Void in
					logVerbose("button \(text) -> \(index)")
					stackVC.first(where: { object -> Bool in
						return object == alertView
					})
					if let win = SystemAlert.privateInstance.window {
						win.isUserInteractionEnabled = false
						win.isHidden = true
					}
					
					completion?(index)
				}))
				idx -= 1
			}

			stackVC.append(alertView)
			viewController?.present(alertView, animated: true)
			
		}

		public class func show(_ title: String?, message: String?, buttons buttonArray: AlertButtonSet, completion: ((_ buttonIndex: Int) -> Void)?) {
			var texts: [String] = []
			for item in buttonArray {
				texts.append(item.text)
			}
			
			SystemAlert.show(nil,
							 title: title,
							 message: message,
							 buttonTexts: texts,
							 completion: { (_ buttonIndex: Int) -> Void in
								 completion?(buttonIndex)
			})
		}

		public class func show(_ title: String?, message: String?, ok okString: String?, cancel cancelString: String?, completion: ((_ ok: Bool) -> Void)?) {
			SystemAlert.show(nil,
							 title: title,
							 message: message,
							 buttonTexts: [cancelString ?? AlertButtons.ok.text, okString ?? AlertButtons.cancel.text],
							 completion: { (_ buttonIndex: Int) -> Void in
								 completion?(buttonIndex == 1)
			})
		}

		public class func show(_ title: String?, message: String?) {
			SystemAlert.show(nil, title: title, message: message, buttonTexts: [AlertButtons.ok.text])
		}
	}
}

