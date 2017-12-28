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
			// if let current = Toaster.ToastCenter.default.currentToast {
			//	current.cancel()
			// }
			
			bread.show()
		}
		
		/// 화면에 떠있는 토스트를 모두 제거.
		static func clear() {
			Toaster.ToastCenter.default.cancelAll()
		}
	}
}
