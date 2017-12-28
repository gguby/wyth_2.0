//
//  String+Tag.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 28..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import Foundation

extension String {
	// hash tag
	
	@discardableResult
	private func logStringTag(_ tag:String) -> String {
		logVerbose("[#TAG:\(tag)] \(self)")
		return self
	}
	
	public var error: String {
		let tag = #function
		return logStringTag(tag)
	}
	
	public var locale: String {
		// TODO : 언어 변환 필요하면 여기에서
		//return _T(self)
		return NSLocalizedString(self, comment: "\(self)")
	}

}

