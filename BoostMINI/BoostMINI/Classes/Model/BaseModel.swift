//
//  BaseModel.swift
//  SMLightStick
//
//  Created by jack on 2017. 12. 18..
//  Copyright © 2017년 jack. All rights reserved.
//
// 이 소스는 굳이 보지 않으셔도 됩니다.
// 간단한 사용 뒤에 숨은 다양한 로직들이 모여있습니다.
import Foundation
import Alamofire



protocol BaseModel: Codable {
	/// 한 모델에 대해 여러 호출을 할 수있도록 dictionary로 저장
	/// key는 보통 HTTPMethod를 사용하지만, 여러 중복 사용을 위해 String으로 저장
	/// "GET2": APIRequest(method: .get ... ) 등의 여러 구조로 사용 가능.
	static var apiList: [String: APIRequest] { get }	// key : HTTPMethod.rawValue = String
}

extension Dictionary where Key: ExpressibleByStringLiteral, Value == APIRequest {
}


//extension APIRequest {
//	static func buildApiRequests() -> [String: APIRequest] {
//		var apis: [String: APIRequest] = [:]
//
//		switch(self) {
//		case is AppsGetResponse:
//			return [:]
//		case is SettingsGetResponse:
//			return [:]
//
//		default:
//			return [:]
//		}
//		return apis
//	}
//
//}

