////
////  ResponseBlock.swift
////  SMLightStick
////
////  Created by jack on 2017. 12. 18..
////  Copyright © 2017년 jack. All rights reserved.
////
//// 이 코드는 보실 필요가 없습니다. 그냥 보려면 복잡하거든요
//
//import UIKit
//import Alamofire
//import CodableAlamofire
//
//public class RequestOption {
//	public let method: HTTPMethod
//	public let parameters: Parameters?
//	public let headers: HTTPHeaders?
//	public convenience init(parameters: Parameters?, headers: HTTPHeaders?) {
//		self.init(.get, parameters: parameters, headers: headers)
//	}
//	
//	public init(_ method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?) {
//		self.method = method
//		self.parameters = parameters
//		self.headers = headers
//	}
//}
//
//
//
//
//class ResponseBlock<S: BaseModel> {
//	var error: Error?	// = nil
//	var data: [S]?		// = nil
//	var first: S? {
//		return data?.first
//	}
//	var isSucceed: Bool {
//		return error != nil || data != nil
//	}
//	
//	init() { }
//	convenience init(from: DataResponse<[S]>) throws {
//        if let response = from.response, response.isNotOk {
//            throw BSTError.api(APIError(rawValue: response.statusCode)!)
//        }
//        
//		self.init(data:from.result.value, error:from.error)
//	}
//	convenience init(from: DataResponse<S>) throws {
//        if let response = from.response, response.isNotOk {
//            throw BSTError.api(APIError(rawValue: response.statusCode)!)
//        }
//        
//		let arr: [S] = from.result.value == nil ? [] : [from.result.value!]
//		self.init(data:arr, error:from.error)
//	}
//	init(data: [S]?, error: Error?) {
//		self.error = error ?? self.error
//		self.data = data ?? self.data
//	}
//}
//
