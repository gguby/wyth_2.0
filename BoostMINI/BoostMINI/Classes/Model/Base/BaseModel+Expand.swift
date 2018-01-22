//
//  BaseModel+Expand.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 19..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit

extension BaseModel {
	var expand: Bool {
		get {
			let str = objc_getAssociatedObject(self, "objc_select") as? String ?? ""
			return !str.isEmpty
		}
		set {
			let value = expand ? "expanded" : ""
			objc_setAssociatedObject(self, "objc_select", value, .OBJC_ASSOCIATION_RETAIN)
		}
	}
	mutating func reverseExpand() {
		expand = !expand
	}
}

