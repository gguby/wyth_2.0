//
//  Extension+StoredProperties.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 15..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import Foundation


protocol PropertyStoring {
	associatedtype T
	func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: T) -> T
}
extension PropertyStoring {
	func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: T) -> T {
		guard let value = objc_getAssociatedObject(self, key) as? T else {
			return defaultValue
		}
		return value
	}
}


