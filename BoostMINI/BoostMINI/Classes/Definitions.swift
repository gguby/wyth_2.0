//
//  Definitions.swift
//  BoostMINI
//
//  시스템 전체에서 사용되는 common/specific한 값들을 저장함.
//
//  Created by HS Lee on 20/12/2017.
//  Copyright © 2017 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit

enum PaginationDirection {
    case Upward, DownWard
}

class Definitions {
    
    static let kdNavigationBarHeight: CGFloat = 44  //53 //add statusbar height
    static let kdTabBarHeight: CGFloat = 48.0 //66.0
    
    //    static let uiThemeMainColor = MLColor.aquamarineColor()
    
    static var gKeyboardRect = CGRect.zero
    static let pageSize = 10
}
