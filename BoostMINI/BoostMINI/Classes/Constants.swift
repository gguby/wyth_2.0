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
    typealias server = BSTServer
    typealias path = BSTPath

    //    class var server: RDServer {
    //        return RDServer.Type
    //    }
}

internal struct BSTServer {

    static var domain: String {
        return "" // JDUserDefaults.defaults.objectForKey(key: "host") as? String ?? "ftp://hellopp.net:21"
    }

    static var uid: String {
        return "" // JDUserDefaults.defaults.objectForKey(key: "username") as? String ?? "jino"
    }

    static var pwd: String {
        return "" // JDUserDefaults.defaults.objectForKey(key: "password") as? String ?? "choij7575"
    }

    static var path: String {
        return "" // JDUserDefaults.defaults.objectForKey(key: "path") as? String ?? "/test/jinjin"
    }

    static var versionInf = "version.inf"
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

internal enum BSTSystem: String {
    case misc = ""
}
