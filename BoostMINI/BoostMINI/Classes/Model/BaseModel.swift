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


public class APIMethod: NSObject {
	/// 기본 도메인 주소 (손대지 않으면 기본 주소 제공)  / 으로 끝남.
	var baseDomain: String

	/// 기본 경로. 도메인을 제외한 나머지 주소.  도메인 루트 기준.
	var path: String
	
	/// 기본 파라미터.
	var option: RequestOption!

	/// result에서 데이터를 가져올 json 헤더 위치. (Boost API는 {code, msg, data:[...]} 형식이다.)
	var resultKeyPath: String = "data"

	/// 서버에서 json 객체가 배열로 반환되는지 한 개만 반환되는지의 여부 반환. (한 개일지라도 편의를 위해 오브젝트 저장은 1개짜리 배열로 저장됨)
	var isArrayResult: Bool = true
	
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

	// 구 singleAPI 기능.  APIMethod 하나를 딕셔너리 형태로변환하여 반환.
	public func asGroup(_ key:String? = nil) -> [String: APIMethod] {
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
				isArrayResult: Bool? = nil) {
		
		let baseDomain = (domain ?? "")
		self.baseDomain = baseDomain.isEmpty ? Definitions.api.base : baseDomain
		self.path = path
		self.option = option ?? RequestOption(method ?? .get, parameters: parameters, headers: headers)
		if let temp = resultKeyPath { self.resultKeyPath = temp }	// ""일 경우, 자동으로 nil로 변환하여 처리한다. 즉, 루트를 읽어온다.
		if let temp = isArrayResult { self.isArrayResult = temp }
	}
	
	public convenience init(_ path: String,
							_ method: HTTPMethod = .get,
							_ parameters: Parameters? = nil,
							map: String? = nil,
							headers: HTTPHeaders? = nil,
							isArrayResult: Bool? = nil) {
		
		var param: [String: Any] = parameters ?? [:]
		if let tempMap = map {
			for key in tempMap.split(separator: ",") {
				let key = "\(key)", val = "$(\(key))"
				param.setObjectOrIgnore(val, forKey: key)	// param에 이미 있는 key라면 무시됨. (추천하지않음. map을쓸거면 parameters는 없거나 map과 중복되지않게 사용을권장)
			}
		}
		let option = RequestOption(method, parameters: param, headers: headers)
		self.init(path: path, option: option, method: method, parameters: param, headers: headers, isArrayResult: isArrayResult)
	}
	
	public convenience init(_ path: String,
							_ parameters: Parameters? = nil) {
		let option = RequestOption(.get, parameters: parameters, headers: nil)
		self.init(path: path, option: option, method: .get, parameters: parameters, headers: nil, isArrayResult: nil)
	}

}

protocol BaseModel: Codable {
	/// 한 모델에 대해 여러 호출을 할 수있도록 dictionary로 저장
	/// key는 보통 HTTPMethod를 사용하지만, 여러 중복 사용을 위해 String으로 저장
	/// "GET2": APIMethod(method: .get ... ) 등의 여러 구조로 사용 가능.
	static var apiList: [String: APIMethod] { get }	// key : HTTPMethod.rawValue = String
}

extension Dictionary where Key: ExpressibleByStringLiteral, Value == APIMethod {
}



extension BaseModel {
	
	// deprecated
	// singleApi(##) -> ##.asGroup()
//	static func singleApi(_ api: APIMethod, _ key: String? = nil) -> [String: APIMethod] {
//		let k: String = key ?? api.getMethod().rawValue
//		return [k: api]
//	}

	static func buildBase(method: HTTPMethod = .get,
						  parameters: Parameters? = nil,
						  headers: HTTPHeaders? = nil) -> DataRequest? {

		guard let api = apiList[method.rawValue] else {
				return nil
		}
		return buildBase(api: api, parameters: parameters, headers: headers)
	}
	
	static func buildBase(api: APIMethod,
						  parameters: Parameters? = nil,
						  headers: HTTPHeaders? = nil) -> DataRequest? {
		guard let option = api.option,
			let urlReq = api.url() else {
				return nil
		}
		
		let method = option.method
		let parameters = option.parameters
		let headers = option.headers

		return Alamofire.request(urlReq,
								 method: method,
								 parameters: parameters,
								 encoding: URLEncoding(destination: .methodDependent),
								 headers: headers)
	}

}


