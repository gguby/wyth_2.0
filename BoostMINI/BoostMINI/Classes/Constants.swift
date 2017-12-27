//
//  Constants.swift
//  BoostMINI
//
//  - Constants 값 설정
//
//  Created by HS Lee on 20/12/2017.
//  Copyright © 2017 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit

internal class BSTConstants {
    typealias main  = BSTMainViewContants
}

internal struct BSTMainViewContants {
    
    static let kdNavigationBarHeight: CGFloat = 44 // 53 //add statusbar height
    static let kdTabBarHeight: CGFloat = 48.0 // 66.0
//    static let uiThemeMainColor = MLColor.aquamarineColor()
    static var gKeyboardRect = CGRect.zero
    static let pageSize = 10
}

internal enum BSTSystem: String {
    case misc = ""
}
