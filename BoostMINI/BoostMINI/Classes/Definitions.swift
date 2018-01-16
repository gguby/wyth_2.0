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

struct Definitions {
	// API 서버

	static let api = BSTAPIServer()
    static let device = BSTDevice()
    
    // 기타 경로
    static let externURLs = BSTExternalURL()
	
	private init() { }
}




public struct BSTAPIServer {
	
	/// api server base url
	let base = "http://boostdev.lysn.com/"
	let baseJson = "http://boostdev.lysn.com/v2/api-docs?group=API"
	let path = BSTPath()
}

internal struct BSTPath {
	let notifications = BSTNotificationsPath()
	//let login = BSTLoginPath()
}

internal struct BSTExternalURL {

	/// 앱스토어 페이지 경로
	var appstore: String = "itms-apps://itunes.apple.com/app/id1190512555"
	
	/// 로그인 관련 클라이언트 아이디
	let clientId = "8ecafcf23f6d42cf94806ab807bd2023"
	
	let authLogout = "https://membership.smtown.com/Account/SignOut"
	/// 로그인 페이지 경로 (O-Auth)
	let authUri = "https://api.smtown.com/OAuth/Authorize?client_id=8ecafcf23f6d42cf94806ab807bd2023&redirect_uri=http://api.dev2nd.vyrl.com/&state=nonce&scope=profile&response_type=token"
	
//	let authUri = "https://api.smtown.com/OAuth/Authorize?client_id=8ecafcf23f6d42cf94806ab807bd2023&redirect_uri=https://api.smtown.com/&state=nonce&scope=profile&response_type=token"
	
	// TODO: 이용약관 보기
	let terms = "https://membership.smtown.com/Policy/Terms"
	// TODO: 개인정보 처리 방침
	let privacy = "https://membership.smtown.com/Policy/Privacy"
	
}


enum BSTNotificationsPath2 {
    case getList(String, Int)
    case get(Int)
    
    var path: String {
		switch self {
		case let .getList(lastPushId, count):
			return "/push/list/\(lastPushId)/\(count)"
		case let .get(lastPushId):
			return "/push/\(lastPushId)"
		}
	}
}

internal struct BSTNotificationsPath {
    ///push/list/lastPushId/count 3안
    let getList2 = "/push/list/%@/%d"
    func getList(lastPushId: String, count: Int) -> String {//4안
        return "/push/list/\(lastPushId)/\(count)"
    }
//    enum ... case aaa(c,d) ... // 5
}

internal struct BSTDevice {
    let service_UUID = "E20A39F4-73F5-4BC4-A12F-17D1AD666661" // uuid spec
    let characteristic_UUID = "08590F7E-DB05-467E-8757-72F6F66666D4" // uuid spec
}
