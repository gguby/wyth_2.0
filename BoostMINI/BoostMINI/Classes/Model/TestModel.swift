//
//  TestModel.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 28..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import Alamofire

class TestData: BaseModel {
	
	static var apiList: [String: APIMethod] {
		//let apiGet = APIMethod(nil)
		
		// 와... qaapi 서버 내렸네 ㅋㅋ
//		let apiGet = APIMethod(domain: "https://qaapi.lysn.com/lysn-api/",
//							   path: "api/common/app/config?v=1.0.0?",
//							   method: .get,
//							   parameters: nil,
//							   headers: nil)

		let apiGet = APIMethod(domain: "https://httpbin.org/",
							   path: "get",
							   method: .get,
							   parameters: ["test": 123],
							   headers: nil,
							   resultKeyPath: "headers")
//		let apiGet = APIMethod(domain: "https://httpbin.org/",
//							   path: "get",
//							   option: RequestOption(.get, parameters: ["test": 123])
//							   resultKeyPath: "headers")

		
		let block: [String: APIMethod] = [apiGet.getMethod().rawValue : apiGet]
		// let block: [String: APIMethod] = ["GET" : apiGet, "LIST": apiGet2] // ex
		return block
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



