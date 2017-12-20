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
    //    class var server: RDServer {
    //        return RDServer.Type
    //    }
}

internal struct BSTServer {
    
    static var domain: String {
        get {
            return "" //JDUserDefaults.defaults.objectForKey(key: "host") as? String ?? "ftp://hellopp.net:21"
        }
    }
    
    static var uid: String {
        get {
            return "" //JDUserDefaults.defaults.objectForKey(key: "username") as? String ?? "jino"
        }
    }
    
    static var pwd: String {
        get {
            return "" //JDUserDefaults.defaults.objectForKey(key: "password") as? String ?? "choij7575"
        }
    }
    
    static var path: String {
        get {
            return "" //JDUserDefaults.defaults.objectForKey(key: "path") as? String ?? "/test/jinjin"
        }
    }
    
    static var versionInf = "version.inf"
}

internal enum BSTSystem: String {
    case misc = ""
}

