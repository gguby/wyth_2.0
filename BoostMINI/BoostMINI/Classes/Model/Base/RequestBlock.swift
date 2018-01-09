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
//import CodableAlamofire

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
	var data: S?		// = nil
	
	init() { }

	convenience init(from: Response<S>?) throws {
		// swagger's
		guard let response = from else {
			throw BSTError.nilError
		}
		if response.isNotOk {
			throw BSTError.api(APIError(rawValue: response.statusCode)!)
		}
		
		let data = response.body as? S
		self.init(data:data)
	}

	
	init(data: S?) {
		self.data = data ?? self.data
	}
}


