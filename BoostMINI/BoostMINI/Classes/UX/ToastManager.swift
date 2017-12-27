//
//  ToastManager.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 21..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import Toaster
import UIKit

/// 토스트를 띄운다.
///
/// - Parameters:
///   - message: 메시지
///   - delay: 지연시간
///   - duration: 노출시간
func Toast(_ message: String,
           delay: TimeInterval = ToastManager.delay,
           duration: TimeInterval = ToastManager.duration) {
    ToastManager.pop(message, delay: delay, duration: duration)
}

/// 토스트를 띄운다.
/// 만약 이미 떠있거나 대기중인 토스트가 있으면 모두 닫고 토스트를 띄운다.
///
/// - Parameters:
///   - message: 메시지
///   - delay: 지연시간
///   - duration: 노출시간
func ToastFirst(_ message: String,
                delay: TimeInterval = ToastManager.delay,
                duration: TimeInterval = ToastManager.duration) {
    ToastManager.clear()
    ToastManager.pop(message, delay: delay, duration: duration)
}

class ToastManager: NSObject {

    fileprivate static let delay: TimeInterval = 0
    fileprivate static let duration: TimeInterval = Toaster.Delay.short

    /// 토스트를 띄운다.
    /// show로 해야하나?... 토스트머신 생각하고 pop이라 했더니 내가 못찾네 =ㅁ=;;;아니, 그냥 글로벌 함수로 써라. Toast(...)
    ///
    /// - Parameters:
    ///   - message: 보여줄 메시지
    ///   - delay: 뜨기 전 지연시간
    ///   - duration: 노출시간
    static func pop(_ message: String,
                    delay: TimeInterval = ToastManager.delay,
                    duration: TimeInterval = ToastManager.duration) {
        let bread = Toaster.Toast(text: message, delay: delay, duration: duration)
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
