//
//  Optional+logError.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 28..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import UIKit

extension Optional {

	/// 값이 nil 이면 에러로그를 쓰는 구현.
	///
	/// - 예> if let val = value.unwrap() {  ... }
	///
	/// - 예> let sum = original + (value.unwrap() ?? 0)
	///
	/// - Parameters:
	/// - Returns: 원본 그대로.
	
	
	
	///
	///
	/// - Parameters:
	///   - completion: self가 nil이 아니면 실행될 클로져 블록.
	/// - Returns: self
	public func unwrap(_ completion: @escaping (Wrapped) -> Void,
					   _ file: String = #file, _ function: String = #function, _ line: Int = #line) -> Optional {
		if let val =  self {
			completion(val)
		} else {
			logError("\(self.debugDescription) is nil... (unwrap error)",
				context: nil,
				file: file,
				function: function,
				line : line)
		}
		return self
	}
}
