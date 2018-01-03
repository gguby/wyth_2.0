//
//  NSObject+ClassNameToString.swift
//  SMLightStick
//
//  Created by jack on 2017. 12. 14..
//  Copyright © 2017년 jack. All rights reserved.
//

import UIKit
import class Foundation.NSObject

extension NSObject {
	
	var typeName: String {
		return self.getTypeName()
	}
	
	func getTypeName() -> String {
		let some: Any = self
		return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
	}
	
}

