//
//  BSTError.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 27..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import UIKit

protocol BSTErrorProtocol: LocalizedError {
	var code: Int { get }
	var title: String! { get }
}

class BSTError: BSTErrorProtocol {
	
	// TODO: 임시생성.
	
    static let isEmpty       = BSTError(101)
    static let argumentError = BSTError(102)
    static let nilError      = BSTError(103)
    static let unknown       = BSTError(999)

	var code: Int
    var title: String!
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }

    private var _description: String = ""

	init(_ code: Int) {
		self.code = code
		self.title = "Error #\(code)"
	}

	convenience init(_ code: Int, _ title: String?, description: String = "") {
		self.init(code)
		self.title = title ?? "Error ##\(code)"
        self._description = description
    }
	
	func action() {
		logError("BSTERROR : \(self.title)")
	}
}
