//
//  URLRequest+CodegenExtension.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 19..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import Alamofire

extension URLRequest {
	/// JSONDataEncoding.encoding(...)의 부분 확장을 위한 코드.
	public mutating func asURLRequestWithParams(_ parameters: Parameters?) -> URLRequest {
		guard let params = parameters, params[JSONDataEncoding.jsonDataKey] == nil else {
			// 이미 처리되었을 것이므로 패스 (JSONDataEncoding.jsonDataKey에 뭔가가 있으면 일단 무조건 패스)
			return self
		}
		
		// 이미 뭔가가 들어있으므로 패스
		if self.httpBody != nil {
			return self
		}
		
		var components = URLComponents()
		components.queryItems = params.map { URLQueryItem(name: $0, value:"\($1)") }
		if let body = components.url?.absoluteString {
			self.httpBody = body.data(using: .utf8)
			// body는 ?select=1 따위로 만들어짐.
		}
		
		return self
		
	}
}

