//
//  BaseModel+Select.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 19..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit

extension BaseModel {
	var select: Bool {
		get {
			return objc_getAssociatedObject(self, "objc_select") as? Bool ?? false
		}
		set {
			objc_setAssociatedObject(self, "objc_select", newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}
}

