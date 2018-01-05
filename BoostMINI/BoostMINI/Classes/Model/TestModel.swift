//
//  TestModel.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 28..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import Alamofire

class TestModel: BaseModel {
	
	static var apiList: [String: APIRequest] {
		return APIRequest(domain: "https://httpbin.org/",
						 path: "get",
						 method: .get,
						 parameters: ["test": 123],
						 headers: nil,
						 resultKeyPath: "headers").asGroup()
	}

	
	let connection: String
	let host: String
	let userAgent: String
	
	private enum CodingKeys: String, CodingKey {
		case connection = "Connection"
		case host = "Host"
		case userAgent = "User-Agent"
	}
	
	
	var description: String {	// DEBUGGING ONLY
		return "\(connection), \(host), \(userAgent)"
	}
}



