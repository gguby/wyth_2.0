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
			.ok       : "확인".locale,
			.cancel   : "취소".locale,
			//.ignore : "무시".locale,
			.yes      : "예".locale,
			.no       : "아니오".locale,
			.like     : "좋아요".locale,
			.prev     : "이전".locale,
			.next     : "다음".locale,
			.appStore : "앱스토어로 이동".locale
		]
		
		return map[self] ?? "\(self)"
	}
}

public typealias AlertButtonSet = [AlertButtons]



// 외부에서 바로 호출못하도록 BSTUXHanlder 내부에 생성
extension BSTUXHanlder {


	
	internal class SystemAlertViewController: UIViewController {
		var presentedStatusBarStyle = UIStatusBarStyle.default
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

	

	
	
	internal class SystemAlert: NSObject {

		class func show(_ sender: UIViewController?,
						title: String?,
						message: String?,
						buttonTexts: [String] = [AlertButtons.ok.text],
						completion: ((_ buttonIndex: Int) -> Void)? = nil) {
			
			// INFO: 비디오 플레이어처럼 상태표시줄이 없어야 되는 경우는, 상태표시줄이 없는 알럿으로 띄워줘야함..
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
			var idx: Int = buttonTexts.count - 1	// zero based.

			// 역순으로 표시. (우측부터)
			for text in buttonTexts.reversed() {
				let index = idx
				alertView.addAction(UIAlertAction(title: text, style: .default, handler: { (_: UIAlertAction) -> Void in
					logVerbose("button \(text) -> \(index)")
					completion?(index)
				}))
				idx -= 1
			}

			viewController?.present(alertView, animated: true)
			// alertView.view.tintColor = UIColor(hexString: "#313131")
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

