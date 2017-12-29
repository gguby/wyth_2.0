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
	
	// 높이는 디바이스에 따라 44가 아닐 수 있다.
    static let kdNavigationBarHeight: CGFloat = 44 // 53 //add statusbar height
    static let kdTabBarHeight: CGFloat = 48.0 // 66.0
//    static let uiThemeMainColor = MLColor.aquamarineColor()
    static var gKeyboardRect = CGRect.zero
    static let pageSize = 10
	
	
	
	
	static var appVersion: String {
		let version = ProcessInfo.processInfo.operatingSystemVersion
		let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
		return versionString
	}

	
	
}

internal enum BSTSystem: String {
    case misc = ""
}
