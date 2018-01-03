//
//  LoginModel.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 29..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import Alamofire

class LoginModel : BaseModel {
	
	public struct loginType {
		static let login    = "login"
		static let join     = "join"
		static let logout   = "logout"
		static let info     = "info"
		static let withdraw = "withdraw"
	}
	
	static var apiList: [String: APIMethod] {
		return [
			loginType.login: APIMethod("customer/login/smtown", .post, nil, map: "deviceId,deviceType,pushRegId"),
			loginType.join: APIMethod("customer/join/smtown", .post, nil, map: "deviceId,deviceType,pushRegId"),
			loginType.logout: APIMethod("customer/logout", .get, nil),
			loginType.info: APIMethod("customer/info", .get, nil, map: "deviceId,deviceType,pushRegId"),
			loginType.withdraw: APIMethod("customer/info", .get, nil, map: "deviceId,deviceType,pushRegId")
		]
	}
	
	let userName: String
	let userEmail: String
	
	private enum CodingKeys: String, CodingKey {
		case userName
		case userEmail
	}
}


extension LoginModel {
	
	var description: String {	// DEBUGGING ONLY
		return "\(userName) (\(userEmail))"
	}
	
	
	
	
	
}
