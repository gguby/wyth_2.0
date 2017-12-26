//
//  String+Format.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 22..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import Foundation


extension String {
	
	/// formatted string이 필요할 때 사용
	/// 	String(format:[FORMAT...] , arguments:[ARGS...]) 를
	/// 	"[FORMAT...]".format([ARGS...]) 로 호출
	///
	/// ex)
	///    "%02d".format(13)
	///
	/// - Parameter parameters: arguments
	/// - Returns: formatted string
	func format(_ parameters: CVarArg...) -> String {
		return String(format: self, arguments: parameters)
	}
	
	
	/// 문자열 길이... count의 타입을 Int로 처리하여 반환.
	///
	/// - Returns: 문자열 길이.
	func length() -> Int {	// 귀찮아서
		return self.count as Int
	}
	
	
}



