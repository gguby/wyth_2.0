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
	
	static var apiList: [String: APIMethod] = [:]
	
	let userName: String
	let userEmail: String
	
	private enum CodingKeys: String, CodingKey {
		case userName
		case userEmail
	}
	
	var description: String {	// DEBUGGING ONLY
		return "\(userName) (\(userEmail))"
	}

}


extension LoginModel {
	
//	loginType.login: APIMethod("customer/login/smtown", .post, nil, map: "deviceId,deviceType,pushRegId"),
//	loginType.join: APIMethod("customer/join/smtown", .post, nil, map: "deviceId,deviceType,pushRegId"),
//	loginType.logout: APIMethod("customer/logout", .get, nil),
//	loginType.info: APIMethod("customer/info", .get, nil, map: "deviceId,deviceType,pushRegId"),
//	loginType.withdraw: APIMethod("customer/info", .get, nil, map: "deviceId,deviceType,pushRegId")

	
	static func login(deviceId: String, deviceType: String, pushRegId: String, _ block: @escaping (ResponseBlock<LoginModel>) -> Void ) {
		let api = APIMethod("customer/login/smtown", .post, [
			"deviceId": deviceId,
			"deviceType": deviceType,
			"pushRegId": pushRegId
			])
		self.custom(api: api, block)
	}

	static func logout(_ block: @escaping (ResponseBlock<LoginModel>) -> Void ) {
		let api = APIMethod("customer/logiyt", .get, nil)
		self.custom(api: api, block)
	}
	
	static func join(deviceId: String, deviceType: String, pushRegId: String, _ block: @escaping (ResponseBlock<LoginModel>) -> Void ) {
		let params: Parameters = [
			"deviceId": deviceId,
			"deviceType": deviceType,
			"pushRegId": pushRegId
		]
		let api = APIMethod("customer/join/smtown", .post, params)
		self.custom(api: api, block)
	}
	
	static func info(deviceId: String, deviceType: String, pushRegId: String, _ block: @escaping (ResponseBlock<LoginModel>) -> Void ) {
		let params: Parameters = [
			"deviceId": deviceId,
			"deviceType": deviceType,
			"pushRegId": pushRegId
		]
		let api = APIMethod("customer/join/smtown", .get, params)
		self.custom(api: api, block)
	}

	
	static func withdraw(deviceId: String, deviceType: String, pushRegId: String, _ block: @escaping (ResponseBlock<LoginModel>) -> Void ) {
		let params: Parameters = [
			"deviceId": deviceId,
			"deviceType": deviceType,
			"pushRegId": pushRegId
		]
		let api = APIMethod("customer/join/smtown", .get, params)
		self.custom(api: api, block)
	}

}