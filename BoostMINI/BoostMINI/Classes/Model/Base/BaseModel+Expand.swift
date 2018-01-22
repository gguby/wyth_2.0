//
//  BaseModel+Expand.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 19..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import ObjectiveC

private var AssociationExpandKey: String = "expandKey"

extension BaseModel {
    
	var expand: Bool {
		get {
			return objc_getAssociatedObject(self, &AssociationExpandKey) as? Bool ?? false
		}
		set {
            objc_setAssociatedObject(self, &AssociationExpandKey, newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}
	mutating func reverseExpand() {
		expand = !expand
	}
}

