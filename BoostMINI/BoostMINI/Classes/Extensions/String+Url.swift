//
//  String+Url.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 27..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import UIKit

extension String {
	var asUrl: URL? { return URL(self) }

}

extension String {
	func encodeURL() -> String {
		guard let ret = self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
			logWarning("encodeURL() error - \(self)")
			return self
		}
		return ret
	}
	
	func decodeURL() -> String {
		guard let ret = self.removingPercentEncoding else {
			logWarning("decodeURL() error - \(self)")
			return self
		}
		return ret
	}
	
	public var queryParameters: [String: String] {
		guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
			let queryItems = components.queryItems else {
				return [:]
		}
		var parameters: [String: String] = [:]
		for item in queryItems {
			parameters[item.name] = item.value
		}
		
		return parameters
	}
}
