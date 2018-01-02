//
//  NotificationModel.swift
//  BoostMINI
//
//  Created by HS Lee on 27/12/2017.
//  Copyright © 2017 IRIVER LIMITED. All rights reserved.
//

import Foundation
import Moya
import Mapper
import RxSwift
import RxOptional
import Moya_ModelMapper

enum APICall {
    case getList(lastPushId: String, count: Int)
}

extension APICall: TargetType {
   
    var baseURL: URL {
        return URL(string: "https://api.boostdev.com")!
    }
    
    var path: String {
        switch self {
        case .getList(let lastPushId, let count):
            return "/push/list/\(lastPushId)/\(count)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}

struct NotificationModel: Mappable {

    // MARK: - * properties --------------------
    var code: Int?
    var message: String?
    
    var pushId: Int?
    var title: String?
    var contents: String?
    var readYn: Bool?

    // MARK: - * IBOutlets --------------------


    // MARK: - * Initialize --------------------

    init() {

    }
    
    init(map: Mapper) throws {
        code = map.optionalFrom("code")
        message = map.optionalFrom("msg")
        
        pushId = map.optionalFrom("pushId")
        pushId = map.optionalFrom("title")
        pushId = map.optionalFrom("contents")
        pushId = map.optionalFrom("readYn")
    }

    let provider = MoyaProvider<APICall>()

    // MARK: * Main Logic --------------------
    func getList() {
        let path = Definitions.api.path.notifications.getList(lastPushId: "xxx", count: 1)
    }
}

extension NotificationModel {

}

