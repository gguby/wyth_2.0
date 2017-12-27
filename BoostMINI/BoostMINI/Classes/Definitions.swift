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

//    static let kdNavigationBarHeight: CGFloat = 44 // 53 //add statusbar height
//    static let kdTabBarHeight: CGFloat = 48.0 // 66.0
//
//    //    static let uiThemeMainColor = MLColor.aquamarineColor()
//
//
//    static var gKeyboardRect = CGRect.zero
//    static let pageSize = 10

	
	// API 서버
	typealias api = BSTApiServer
	
	// 기타 경로
	typealias path = BSTPath
	

	
}



internal struct BSTApiServer {
	
	/// api server base url
	static let base = "http://boost.api.dev.com/"
}

internal struct BSTPath {
	// TODO: Lysn 경로
	/// 앱스토어 페이지 경로
	static var appstore: String = "itms-apps://itunes.apple.com/app/id1190512555"
	
	// TODO: Vyrl 경로
	/// 로그인 관련 클라이언트 아이디
	static let clientId = "8ecafcf23f6d42cf94806ab807bd2023"
	
	// TODO: Vyrl 경로
	/// 로그인 페이지 경로 (O-Auth)
	static let authUri = "https://api.smtown.com/OAuth/Authorize?client_id=8ecafcf23f6d42cf94806ab807bd2023&redirect_uri=http://api.dev2nd.vyrl.com/&state=nonce&scope=profile&response_type=token"
}

