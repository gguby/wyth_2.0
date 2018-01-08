////
////  APIRequest.swift
////  BoostMINI
////
////  renamed from APIMethod
////
////  Created by jack on 2018. 1. 5..
////  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
////
//
//import Foundation
//import Alamofire
//
//
//
//
//public class APIRequest: NSObject {
//	/// 기본 도메인 주소 (손대지 않으면 기본 주소 제공)  / 으로 끝남.
//	var baseDomain: String
//	
//	/// 기본 경로. 도메인을 제외한 나머지 주소.  도메인 루트 기준.
//	var path: String
//	
//	/// 기본 파라미터.
//	var option: RequestOption!
//	
//	/// result에서 데이터를 가져올 json 헤더 위치. (Boost API는 {code, msg, data:[...]} 형식이다.)
//	var resultKeyPath: String = "data"
//	
//	/// 서버에서 json 객체가 배열로 반환되는지 한 개만 반환되는지의 여부 반환. (한 개일지라도 편의를 위해 오브젝트 저장은 1개짜리 배열로 저장됨)
//	var isArrayResult: Bool = true
//	
//	/// url을 조합하여 반환해줌.
//	func url() -> URL? {
//		if let base = URL(string: baseDomain) {
//			return base.appendingPathComponent(path)
//		} else {
//			return nil
//		}
//	}
//	/// 내 메소드를 리턴함.
//	public func getMethod() -> HTTPMethod {
//		return option?.method ?? .get
//	}
//	
//	// 구 singleAPI 기능.  APIRequest 하나를 딕셔너리 형태로변환하여 반환.
//	public func asGroup(_ key:String? = nil) -> [String: APIRequest] {
//		return [key ?? self.getMethod().rawValue : self]
//	}
//	
//	/// 생성자.
//	/// option이 있으면 method, parameters, headers가 무시됩니다.
//	/// method(HTTPMethod)가 생략되면 .get으로 지정됩니다.
//	public init(domain: String? = nil,
//				path: String = "",
//				option: RequestOption? = nil,
//				method: HTTPMethod? = nil,
//				parameters: Parameters? = nil,
//				
//				headers: HTTPHeaders? = nil,
//				resultKeyPath: String? = nil,
//				isArrayResult: Bool? = nil) {
//		
//		let baseDomain = (domain ?? "")
//		self.baseDomain = baseDomain.isEmpty ? Definitions.api.base : baseDomain
//		self.path = path
//		self.option = option ?? RequestOption(method ?? .get, parameters: parameters, headers: headers)
//		if let temp = resultKeyPath { self.resultKeyPath = temp }	// ""일 경우, 자동으로 nil로 변환하여 처리한다. 즉, 루트를 읽어온다.
//		if let temp = isArrayResult { self.isArrayResult = temp }
//	}
//	
//	public convenience init(_ path: String,
//							_ method: HTTPMethod = .get,
//							_ parameters: Parameters? = nil,
//							map: String? = nil,
//							headers: HTTPHeaders? = nil,
//							isArrayResult: Bool? = nil) {
//		
//		var param: [String: Any] = parameters ?? [:]
//		if let tempMap = map {
//			for key in tempMap.split(separator: ",") {
//				let key = "\(key)", val = "$(\(key))"
//				param.setObjectOrIgnore(val, forKey: key)	// param에 이미 있는 key라면 무시됨. (추천하지않음. map을쓸거면 parameters는 없거나 map과 중복되지않게 사용을권장)
//			}
//		}
//		let option = RequestOption(method, parameters: param, headers: headers)
//		self.init(path: path, option: option, method: method, parameters: param, headers: headers, isArrayResult: isArrayResult)
//	}
//	
//	public convenience init(_ path: String,
//							_ parameters: Parameters? = nil) {
//		let option = RequestOption(.get, parameters: parameters, headers: nil)
//		self.init(path: path, option: option, method: .get, parameters: parameters, headers: nil, isArrayResult: nil)
//	}
//
//	
////	static func buildApiRequests(_ obj: BaseModel.Type) -> [String: APIRequest] {
////		var apis: [String: APIRequest] = [:]
////		return apis
////	}
//
//}
//
//
//
//
//private class APIRequestHelper<T: BaseModel> {
//	
//	static fileprivate func sendRequest(api _api: APIRequest? = nil, isArray: Bool = false, _ block: @escaping (ResponseBlock<T>) -> Void ) {
//		guard let api = _api,
//			let dataRequest = buildBase(api: api) else {
//				// INFO : critical error
//				print("Developer's misunderstood error : buildBase failed!! (ResponseBlock or url is wrong. \(T.self))")
//				block(ResponseBlock(data: nil, error: BSTError.argumentError))
//				return
//		}
//		// nil로 해줘야 헤더를 읽음. empty는 오류남.
//		let keyPath: String? = api.resultKeyPath.isEmpty ? nil : api.resultKeyPath
//		
//		dataRequest.responseDecodableObject(keyPath: keyPath, decoder: JSONDecoder.base) { (response: DataResponse<T>) in
//			do {
//				let result = try ResponseBlock<T>(from: response)
//				if let error = result.error {
//					logError(error.localizedDescription)
//				}
//				block(result)
//				
//			} catch let error {
//				if case let error as APIError = error {
//					error.cook() //retry, toast, alert ,,
//				}
//			}
//		}
//	}
//	
//	static fileprivate func sendArrayRequest(api _api: APIRequest? = nil, isArray: Bool = false, _ block: @escaping (ResponseBlock<T>) -> Void ) {
//		guard let api = _api,
//			let dataRequest = buildBase(api: api) else {
//				// INFO : critical error
//				print("Developer's misunderstood error : buildBase failed!! (ResponseBlock or url is wrong. \(T.self))")
//				block(ResponseBlock(data: nil, error: BSTError.argumentError))
//				return
//		}
//		// nil로 해줘야 헤더를 읽음. empty는 오류남.
//		let keyPath: String? = api.resultKeyPath.isEmpty ? nil : api.resultKeyPath
//		
//		// 배열 처리부분은 여기만 다르다.
//		dataRequest.responseDecodableObject(keyPath: keyPath, decoder: JSONDecoder.base) { (response: DataResponse<[T]>) in
//			do {
//				let result = try ResponseBlock<T>(from: response)
//				if let error = result.error {
//					logError(error.localizedDescription)
//				}
//				block(result)
//				
//			} catch let error {
//				if case let error as APIError = error {
//					error.cook() //retry, toast, alert ,,
//				}
//			}
//		}
//	}
//	
//	
//	
//	
//	static func buildBase(api: APIRequest? = nil,
//						  method: HTTPMethod = .get,
//						  parameters: Parameters? = nil,
//						  headers: HTTPHeaders? = nil) -> DataRequest? {
//		guard let apiRequest: APIRequest = api ?? T.apiList[method.rawValue],
//			let option = apiRequest.option,
//			let urlReq = apiRequest.url() else {
//				return nil
//		}
//		
//		let method = option.method
//		let parameters = option.parameters
//		let headers = option.headers
//		
//		return Alamofire.request(urlReq,
//								 method: method,
//								 parameters: parameters,
//								 encoding: URLEncoding(destination: .methodDependent),
//								 headers: headers)
//	}
//
//
//
//
//
//
//
//
//
//
//
//	
//	//    fileprivate static func startScan() -> Observable<[ScannedPeripheral]> {
//	//        return self.manager
//	//            .rx_state
//	//            .filter { $0 == .poweredOn }
//	//            .timeout(4.0, scheduler: self.scheduler)
//	//            .take(1)
//	//            .flatMap { _ in self.manager.scanForPeripherals( withServices: [self.boostServiceUUID]) }
//	//            .catchError { _ in
//	//                self.device.error.onNext(DeviceError.scanFailed)
//	//                return .empty()
//	//            }
//	//            .subscribeOn(MainScheduler.instance)
//	//            .toArray()
//	//    }
//	
//	static fileprivate func sendRequest2(api _api: APIRequest? = nil, isArray: Bool = false, _ block: @escaping (ResponseBlock<T>) -> Void ) {
//		guard let api = _api,
//			let dataRequest = buildBase(api: api) else {
//				// INFO : critical error
//				print("Developer's misunderstood error : buildBase failed!! (ResponseBlock or url is wrong. \(T.self))")
//				block(ResponseBlock(data: nil, error: BSTError.argumentError))
//				return
//		}
//		// nil로 해줘야 헤더를 읽음. empty는 오류남.
//		let keyPath: String? = api.resultKeyPath.isEmpty ? nil : api.resultKeyPath
//		
//		dataRequest.responseDecodableObject(keyPath: keyPath, decoder: JSONDecoder.base) { (response: DataResponse<T>) in
//			do {
//				let result = try ResponseBlock<T>(from: response)
//				if let error = result.error {
//					logError(error.localizedDescription)
//				}
//				block(result)
//				
//			} catch let error {
//				if case let error as APIError = error {
//					error.cook() //retry, toast, alert ,,
//				}
//			}
//		}
//	}
//}
//
//
//
//
//extension BaseModel {
//	
//	/// HTTPMethod.get 에 대한 API를 호출하여 값을 받아온다.
//	static func get(_ block: @escaping (ResponseBlock<Self>) -> Void ) {
//		let key = HTTPMethod.get.rawValue
//		APIRequestHelper<Self>.sendRequest(api:Self.apiList[key], block)
//	}
//	
//	static func post(_ block: @escaping (ResponseBlock<Self>) -> Void ) {
//		let key = HTTPMethod.post.rawValue
//		APIRequestHelper<Self>.sendRequest(api:Self.apiList[key], block)
//	}
//	
//	static func put(_ block: @escaping (ResponseBlock<Self>) -> Void ) {
//		let key = HTTPMethod.put.rawValue
//		APIRequestHelper<Self>.sendRequest(api:Self.apiList[key], block)
//	}
//	
//	static func delete(_ block: @escaping (ResponseBlock<Self>) -> Void ) {
//		let key = HTTPMethod.delete.rawValue
//		APIRequestHelper<Self>.sendRequest(api:Self.apiList[key], block)
//	}
//	
//	static func list(_ block: @escaping (ResponseBlock<Self>) -> Void ) {
//		let key = "LIST"
//		APIRequestHelper<Self>.sendRequest(api:Self.apiList[key], block)
//	}
//	
//	static func custom(method: HTTPMethod, _ block: @escaping (ResponseBlock<Self>) -> Void ) {
//		let key = method.rawValue
//		APIRequestHelper<Self>.sendRequest(api:Self.apiList[key], block)
//	}
//	
//	static func custom(string key: String, params: [String: Any], _ block: @escaping (ResponseBlock<Self>) -> Void ) {
//		APIRequestHelper<Self>.sendRequest(api:Self.apiList[key], block)
//	}
//	
//	static func custom(api: APIRequest, _ block: @escaping (ResponseBlock<Self>) -> Void ) {
//		APIRequestHelper<Self>.sendRequest(api:api, block)
//	}
//
//}

