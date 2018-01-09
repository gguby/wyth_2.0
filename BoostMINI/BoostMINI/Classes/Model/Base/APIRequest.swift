//
//  APIRequest.swift
//  BoostMINI
//
//  renamed from APIMethod
//
//  Created by jack on 2018. 1. 5..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import Alamofire




public class APIRequest {
	/// 기본 도메인 주소 (손대지 않으면 기본 주소 제공)  / 으로 끝남.
	var baseDomain: String
	
	/// 기본 경로. 도메인을 제외한 나머지 주소.  도메인 루트 기준.
	var path: String
	
	/// 기본 파라미터.
	var option: RequestOption!
	
	/// result에서 데이터를 가져올 json 헤더 위치.
	var resultKeyPath: String = ""

	/// TODO: 명확한 설명을 입력하시오
	var isBody = false
	
	/// url을 조합하여 반환해줌.
	func url() -> URL? {
		if let base = URL(string: baseDomain) {
			return base.appendingPathComponent(path)
		} else {
			return nil
		}
	}
	/// 내 메소드를 리턴함.
	public func getMethod() -> HTTPMethod {
		return option?.method ?? .get
	}
	
	// 구 singleAPI 기능.  APIRequest 하나를 딕셔너리 형태로변환하여 반환.
	public func asGroup(_ key:String? = nil) -> [String: APIRequest] {
		return [key ?? self.getMethod().rawValue : self]
	}
	
	/// 생성자.
	/// option이 있으면 method, parameters, headers가 무시됩니다.
	/// method(HTTPMethod)가 생략되면 .get으로 지정됩니다.
	public init(domain: String? = nil,
				path: String = "",
				option: RequestOption? = nil,
				method: HTTPMethod? = nil,
				parameters: Parameters? = nil,
				
				headers: HTTPHeaders? = nil,
				resultKeyPath: String? = nil,
				isBody: Bool? = nil) {
		
		let baseDomain = (domain ?? "")
		self.baseDomain = baseDomain.isEmpty ? Definitions.api.base : baseDomain
		self.path = path
		self.option = option ?? RequestOption(method ?? .get, parameters: parameters, headers: headers)
		self.resultKeyPath = resultKeyPath ?? self.resultKeyPath
		self.isBody = isBody ?? self.isBody
	}
	
	public convenience init(_ path: String,
							_ method: HTTPMethod = .get,
							_ parameters: Parameters? = nil,
							map: String? = nil,
							headers: HTTPHeaders? = nil,
							isBody: Bool? = nil) {
		
		var param: [String: Any] = parameters ?? [:]
		if let tempMap = map {
			for key in tempMap.split(separator: ",") {
				let key = "\(key)", val = "$(\(key))"
				param.setObjectOrIgnore(val, forKey: key)	// param에 이미 있는 key라면 무시됨. (추천하지않음. map을쓸거면 parameters는 없거나 map과 중복되지않게 사용을권장)
			}
		}
		let option = RequestOption(method, parameters: param, headers: headers)
		self.init(path: path, option: option, method: method, parameters: param, headers: headers, isBody: isBody)
	}
	
	public convenience init(_ path: String,
							_ parameters: Parameters? = nil) {
		let option = RequestOption(.get, parameters: parameters, headers: nil)
		self.init(path: path, option: option, method: .get, parameters: parameters, headers: nil, isBody: nil)
	}

}




private class APIRequestHelper<T: BaseModel> {
	
	
	static fileprivate func sendRequest(api _api: APIRequest? = nil, _ block: @escaping (ResponseBlock<T>) -> Void ) {
		guard let api = _api,
			let dataRequest = buildBase(api: api) else {
				// INFO : critical error
				print("Developer's misunderstood error : buildBase failed!! (ResponseBlock or url is wrong. \(T.self))")
				BSTError.argumentError.cookError()
				return
		}
		// nil로 해줘야 헤더를 읽음. empty는 오류남.
		let keyPath: String? = api.resultKeyPath.isEmpty ? nil : api.resultKeyPath
		
		dataRequest.execute { responseOptional, err in
			// response: DataResponse<T> -> Response<T>
			do {
				guard let response = responseOptional else {
					return BSTError.nilError.cookError()
				}
				if response.isNotOk {
					throw BSTError.api(APIError(rawValue: response.statusCode)!)
				}
				let result = try ResponseBlock<T>(from: response)
//				if let error = result.error {
//					logError(error.localizedDescription)
//				}
				block(result)

			} catch let error {
				if case let error as APIError = error {
					error.cook() //retry, toast, alert ,,
				} else {
					logError("UNKNOWN ERROR : \(error)")
				}
			}
		}
	}
	
	
	
	static func buildBase(api: APIRequest? = nil,
						  method: HTTPMethod = .get,
						  parameters: Parameters? = nil,
						  headers: HTTPHeaders? = nil) -> RequestBuilder<T>? {
		guard let apiRequest: APIRequest = api ?? T.apiList[method.rawValue],
			let option = apiRequest.option,
			let urlReq = apiRequest.url() else {
				return nil
		}
		
		let method = option.method
		let parameters = option.parameters
		var headers:HTTPHeaders = option.headers ?? [:]
		
		headers["X-APP-Version"] = "ios"
		headers["X-Device"] = "ios"
		headers["Accept-Language"] = "ko-KR"

	
		let URLString = apiRequest.url()?.absoluteString ?? ""
		let requestBuilder: RequestBuilder<T>.Type = BoostMINIAPI.requestBuilderFactory.getBuilder()
		let ro = requestBuilder.init(method: apiRequest.getMethod().rawValue,
									URLString: URLString,
									parameters: parameters,
									isBody: apiRequest.isBody,
									headers: headers)

		return ro
	}

}


extension BaseModel {
	
	/// HTTPMethod.get 에 대한 API를 호출하여 값을 받아온다.
	static func get(_ block: @escaping (ResponseBlock<Self>) -> Void ) {
		let key = HTTPMethod.get.rawValue
		APIRequestHelper<Self>.sendRequest(api:Self.apiList[key], block)
	}
	
	static func post(_ block: @escaping (ResponseBlock<Self>) -> Void ) {
		let key = HTTPMethod.post.rawValue
		APIRequestHelper<Self>.sendRequest(api:Self.apiList[key], block)
	}
	
	static func put(_ block: @escaping (ResponseBlock<Self>) -> Void ) {
		let key = HTTPMethod.put.rawValue
		APIRequestHelper<Self>.sendRequest(api:Self.apiList[key], block)
	}
	
	static func delete(_ block: @escaping (ResponseBlock<Self>) -> Void ) {
		let key = HTTPMethod.delete.rawValue
		APIRequestHelper<Self>.sendRequest(api:Self.apiList[key], block)
	}
	
	static func list(_ block: @escaping (ResponseBlock<Self>) -> Void ) {
		let key = "LIST"
		APIRequestHelper<Self>.sendRequest(api:Self.apiList[key], block)
	}
	
	static func custom(method: HTTPMethod, _ block: @escaping (ResponseBlock<Self>) -> Void ) {
		let key = method.rawValue
		APIRequestHelper<Self>.sendRequest(api:Self.apiList[key], block)
	}
	
	static func custom(string key: String, params: [String: Any], _ block: @escaping (ResponseBlock<Self>) -> Void ) {
		APIRequestHelper<Self>.sendRequest(api:Self.apiList[key], block)
	}
	
	static func custom(api: APIRequest, _ block: @escaping (ResponseBlock<Self>) -> Void ) {
		APIRequestHelper<Self>.sendRequest(api:api, block)
	}

}

