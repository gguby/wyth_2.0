//
//  ResponseBlock.swift
//  SMLightStick
//
//  Created by jack on 2017. 12. 18..
//  Copyright © 2017년 jack. All rights reserved.
//
// 이 코드는 보실 필요가 없습니다. 그냥 보려면 복잡하거든요

import UIKit
import Alamofire
import CodableAlamofire

public class RequestOption {
	public let method: HTTPMethod
	public let parameters: Parameters?
	public let headers: HTTPHeaders?
	public convenience init(parameters: Parameters?, headers: HTTPHeaders?) {
		self.init(.get, parameters: parameters, headers: headers)
	}
	
	public init(_ method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?) {
		self.method = method
		self.parameters = parameters
		self.headers = headers
	}
}

class ResponseBlock<S: BaseModel> {
	var error: Error?	// = nil
	var data: [S]?		// = nil
	var first: S? {
		return data?.first
	}
	var isSucceed: Bool {
		return error != nil || data != nil
	}
	
	init() { }
	convenience init(from: DataResponse<[S]>) {
		self.init(data:from.result.value, error:from.error)
	}
	convenience init(from: DataResponse<S>) {
		let arr: [S] = from.result.value == nil ? [] : [from.result.value!]
		self.init(data:arr, error:from.error)
	}
	init(data: [S]?, error: Error?) {
		self.error = error ?? self.error
		self.data = data ?? self.data
	}
}


class APIService<T: BaseModel> {
	
	static fileprivate func sendRequest(api _api: APIMethod? = nil, isArray: Bool = false, _ block: @escaping (ResponseBlock<T>) -> Void ) {
		guard let api = _api,
			let dataRequest = T.buildBase(api: api) else {
				// INFO : critical error
				print("Developer's misunderstood error : buildBase failed!! (ResponseBlock or url is wrong. \(T.self))")
				block(ResponseBlock(data: nil, error: BSTError.argumentError))
				return
		}
		// nil로 해줘야 헤더를 읽음. empty는 오류남.
		let keyPath: String? = api.resultKeyPath.isEmpty ? nil : api.resultKeyPath
		
		dataRequest.responseDecodableObject(keyPath: keyPath, decoder: JSONDecoder.base) { (response: DataResponse<T>) in
			let result = ResponseBlock<T>(from: response)
			if let error = result.error {
				logError(error.localizedDescription)
			}
			block(result)
		}
	}

	static fileprivate func sendArrayRequest(api _api: APIMethod? = nil, isArray: Bool = false, _ block: @escaping (ResponseBlock<T>) -> Void ) {
		guard let api = _api,
			let dataRequest = T.buildBase(api: api) else {
				// INFO : critical error
				print("Developer's misunderstood error : buildBase failed!! (ResponseBlock or url is wrong. \(T.self))")
				block(ResponseBlock(data: nil, error: BSTError.argumentError))
				return
		}
		// nil로 해줘야 헤더를 읽음. empty는 오류남.
		let keyPath: String? = api.resultKeyPath.isEmpty ? nil : api.resultKeyPath

		// 배열 처리부분은 여기만 다르다.
		dataRequest.responseDecodableObject(keyPath: keyPath, decoder: JSONDecoder.base) { (response: DataResponse<[T]>) in
			let result = ResponseBlock<T>(from: response)
			if let error = result.error {
				logError(error.localizedDescription)
			}
			block(result)
		}
	}
}



extension BaseModel {
	
	/// HTTPMethod.get 에 대한 API를 호출하여 값을 받아온다.
	static func get(_ block: @escaping (ResponseBlock<Self>) -> Void ) {
		let key = HTTPMethod.get.rawValue
		APIService<Self>.sendRequest(api:Self.apiList[key], block)
	}

	static func post(_ block: @escaping (ResponseBlock<Self>) -> Void ) {
		let key = HTTPMethod.post.rawValue
		APIService<Self>.sendRequest(api:Self.apiList[key], block)
	}

	static func put(_ block: @escaping (ResponseBlock<Self>) -> Void ) {
		let key = HTTPMethod.put.rawValue
		APIService<Self>.sendRequest(api:Self.apiList[key], block)
	}

	static func delete(_ block: @escaping (ResponseBlock<Self>) -> Void ) {
		let key = HTTPMethod.delete.rawValue
		APIService<Self>.sendRequest(api:Self.apiList[key], block)
	}

	static func list(_ block: @escaping (ResponseBlock<Self>) -> Void ) {
		let key = "LIST"
		APIService<Self>.sendRequest(api:Self.apiList[key], block)
	}
	
	static func custom(method: HTTPMethod, _ block: @escaping (ResponseBlock<Self>) -> Void ) {
		let key = method.rawValue
		APIService<Self>.sendRequest(api:Self.apiList[key], block)
	}

	static func custom(string key: String, params: [String: Any], _ block: @escaping (ResponseBlock<Self>) -> Void ) {
		APIService<Self>.sendRequest(api:Self.apiList[key], block)
	}

	static func custom(api: APIMethod, _ block: @escaping (ResponseBlock<Self>) -> Void ) {
		APIService<Self>.sendRequest(api:api, block)
	}

}
