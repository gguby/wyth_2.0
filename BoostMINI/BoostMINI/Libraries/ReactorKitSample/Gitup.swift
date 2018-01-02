//
//  GitupEndpoint.swift
//  reactorKitSample
//
//  Created by wsjung on 2017. 12. 14..
//  Copyright © 2017년 wsjung. All rights reserved.
//

import Foundation
import Moya

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

enum GitHub {
    case userProfile(username: String)
    case repos(username: String)
    case repo(fullName: String)
    case issues(repositoryFullName: String)
    case search(query: String?, page: Int)
}

extension GitHub: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .repos(let name):
            return Definitions.api.path.notifications.getList
        case .userProfile(let name):
            return "/users/\(name.urlEscaped)"
        case .repo(let name):
            return "/repos/\(name)"
        case .issues(let repositoryName):
            return "/repos/\(repositoryName)/issues"
        case .search(_,_):
            return "/search/repositories"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    var task: Task {
        switch self {
        case .search(let query, let page):
            return .requestParameters(parameters: ["q" : query!, "page" : page], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
