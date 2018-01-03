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
    
}

extension Definitions {
    internal struct BSTAPIServer {
        
        /// api server base url
        let base = "http://boost.api.dev.com/"
        let path = BSTPath()
    }
    
    internal struct BSTPath {
        let notifications = BSTNotificationsPath()
    }
    
    internal struct BSTExternalURL {
        // TODO: Lysn 경로
        /// 앱스토어 페이지 경로
        var appstore: String = "itms-apps://itunes.apple.com/app/id1190512555"
        
        // TODO: Vyrl 경로
        /// 로그인 관련 클라이언트 아이디
        let clientId = "8ecafcf23f6d42cf94806ab807bd2023"
        
        // TODO: Vyrl 경로
        /// 로그인 페이지 경로 (O-Auth)
        let authUri = "https://api.smtown.com/OAuth/Authorize?client_id=8ecafcf23f6d42cf94806ab807bd2023&redirect_uri=http://api.dev2nd.vyrl.com/&state=nonce&scope=profile&response_type=token"
    }
}

enum BSTNotificationsPath2 {
    case getList(String, Int)
    case get(Int)
    
    var path: String {
        get {
            switch self {
            case let .getList(lastPushId, count):
                return "/push/list/\(lastPushId)/\(count)"
            case let .get(lastPushId):
                return "/push/\(lastPushId)"
            }
        }
    }
}

internal struct BSTNotificationsPath {
    //let getList = "/push/list/\\(lastPushId)/\\(count)" //1안-a
    //let getList = "/push/list/$lastPushId/$count" //2안
    let getList = "/push/list/%@/%d" ///push/list/lastPushId)/count 3안
    func getList2(lastPushId: String, count: Int) -> String {//4안
        return "/push/list/\(lastPushId)/\(count)"
    }
//    enum ... case aaa(c,d) ... // 5
}

internal struct BSTDevice {
    let service_UUID = "713D0000-503E-4C75-BA94-3148F18D941E" // uuid spec
    let characteristic_UUID = "713D0000-503E-4C75-BA94-3148F18D941E" // uuid spec
}


