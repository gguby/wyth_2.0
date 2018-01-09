//
//  HTTPURLResponse+statusCode.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 5..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit

extension HTTPURLResponse {
	
	/// statusCode가 알려진 정상범위인지 확인한다
	var isOk: Bool {
		// 주석을 포함한 아래 세 줄은 모두 동일한 코드
		// !(response.statusCode < 200 || response.statusCode >= 300)
		// return response.statusCode >= 200 && response.statusCode < 300
		return (statusCode / 100) == 2
	}
	
	/// statusCode가 알려진 정상 범위가 아닌지 확인한다
	var isNotOk: Bool {
		return !isOk
	}
}


extension Response {
	
	/// statusCode가 알려진 정상범위인지 확인한다
	var isOk: Bool {
		// 주석을 포함한 아래 세 줄은 모두 동일한 코드
		// !(response.statusCode < 200 || response.statusCode >= 300)
		// return response.statusCode >= 200 && response.statusCode < 300
		return (statusCode / 100) == 2
	}
	
	/// statusCode가 알려진 정상 범위가 아닌지 확인한다
	var isNotOk: Bool {
		return !isOk
	}
}
