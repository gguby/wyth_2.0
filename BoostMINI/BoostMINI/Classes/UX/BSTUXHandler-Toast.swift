//
//  ToastManager.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 21..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import Toaster
import UIKit

/// 외부에서 바로 호출못하도록 BSTUXHanlder 내부에 생성
extension BSTUXHanlder {
	internal class ToastManager: NSObject {
		fileprivate static let delay: TimeInterval = 0
		fileprivate static let duration: TimeInterval = Toaster.Delay.short
		
		/// 토스트를 띄운다.
		///
		/// - Parameters:
		///   - message: 보여줄 메시지
		///   - delay: 뜨기 전 지연시간
		///   - duration: 노출시간
		static func pop(_ message: String,
						delay: TimeInterval? = nil,
						duration: TimeInterval? = nil,
						clearStack: Bool = false) {
			if clearStack {
				clear()
				if message.isEmpty && delay == nil && duration == nil {
					
					
				}
			}
			
			let bread = Toaster.Toast(text: message,
									  delay: delay ?? ToastManager.delay,
									  duration: duration ?? ToastManager.duration)
			bread.show()
		}
		
		
		
		/// 에러 스타일 토스트를 띄운다.
		///
		/// - Parameters:
		///   - message: 보여줄 메시지
		///   - delay: 뜨기 전 지연시간
		///   - duration: 노출시간
		static func popError(_ message: String,
						delay _delay: TimeInterval? = nil,
						duration _duration: TimeInterval? = nil) {
			
			let delay = _delay ?? 0
			var duration = _duration ?? Toaster.Delay.long
			duration += TimeInterval((message.length() / 48) * 2)
			
			let bread = Toaster.Toast(text: "\n\(message)\n",
									  delay: delay,
									  duration: duration)
			let view = bread.view
			view.backgroundColor = UIColor.init("#691818")
			view.textColor = UIColor.init("#ffffc8")
			view.borderColor = UIColor.init("#ec9fac")
			view.font = BSTFacade.theme.font.smtownotfBold(size: 14.0)

			bread.show()
		}
		
		
		/// 화면에 떠있는 토스트를 모두 제거.
		static func clear() {
			Toaster.ToastCenter.default.cancelAll()
		}
	}
}


