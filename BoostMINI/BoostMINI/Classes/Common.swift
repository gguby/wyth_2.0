//
//  Common.swift
//  BoostMINI
//
//  - 여러가지 공통 클래스들을 정의함.
//
//  Created by HS Lee on 20/12/2017.
//  Copyright © 2017 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit

class BSTApplication {
    static let shortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
}

struct BSTScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxValue = max(BSTScreenSize.width, BSTScreenSize.height)
    static let minValue = min(BSTScreenSize.width, BSTScreenSize.height)
    static let bounds = UIScreen.main.bounds
}

struct BSTAnimation {
//    static let duration = UIDevice.current.systemVersion.floatValue >= 5.0 ? 0.3 : 0.25
}

enum BSTDeviceType {

    case iPhone4orLess, iPhone5, iPhone6, iPhone6p

    static let isIPhone4orLess = BSTDeviceType.userInferfaceIdiom == .phone && BSTScreenSize.maxValue < 568.0
    static let isIPhone5orLess = BSTDeviceType.userInferfaceIdiom == .phone && BSTScreenSize.maxValue <= 568.0
    static let isIPhone5 = BSTDeviceType.userInferfaceIdiom == .phone && BSTScreenSize.maxValue == 568.0
    static let isIPhone6 = BSTDeviceType.userInferfaceIdiom == .phone && BSTScreenSize.maxValue == 667.0
    static let isIPhone6p = BSTDeviceType.userInferfaceIdiom == .phone && BSTScreenSize.maxValue == 736.0
    static let isIPad = BSTDeviceType.userInferfaceIdiom == .pad

    static var userInferfaceIdiom: UIUserInterfaceIdiom {
        return UIDevice.current.userInterfaceIdiom
        //            if UIDevice.currentDevice().systemVersion.floatValue >= 8.3 {
        //                return UI_USER_INTERFACE_IDIOM()
        //            } else {
        //            }
    }

    static var isSimulator: Bool {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return true
        #else
            return false
        #endif
    }

    init() {
        if BSTDeviceType.isIPhone5 {
            self = .iPhone5
        } else if BSTDeviceType.isIPhone6 {
            self = .iPhone6
        } else if BSTDeviceType.isIPhone6p {
            self = .iPhone6p
        } else {
            self = .iPhone4orLess
        }
    }
}
