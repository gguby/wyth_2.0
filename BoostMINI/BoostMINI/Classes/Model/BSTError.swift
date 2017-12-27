//
//  BSTError.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 27..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import UIKit

enum BSTError: Error {
    case isEmpty
    case argumentError
    case nilError
    case unknown
    case custom(msg)
}

protocol BSTErrorProtocol: LocalizedError {
    var title: String? { get }
    var code: Int { get }
}

struct BSTError: BSTErrorProtocol {

    var title: String?
    var code: Int
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }

    private var _description: String

    init(title: String?, description: String, code: Int) {
        self.title = title ?? "Error"
        _description = description
        self.code = code
    }
}
