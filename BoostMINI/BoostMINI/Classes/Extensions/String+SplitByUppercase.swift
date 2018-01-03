//
//  String+SplitByUppercase.swift
//  SMLightStick
//
//  Created by jack on 2017. 12. 13..
//  Copyright © 2017년 jack. All rights reserved.
//
import Foundation

// 해당 조건에 맞게 split 해줌.
extension Sequence {
	func splitBefore(
		separator isSeparator: (Iterator.Element) throws -> Bool
		) rethrows -> [String] {
		var result: [String] = []
		var subSequence: [String] = []
		
		var iterator = self.makeIterator()
		while let element = iterator.next() {
			if try isSeparator(element) {
				if !subSequence.isEmpty {
					result.append(subSequence.joined())
				}
				subSequence = ["\(element)"]
			} else {
				subSequence.append("\(element)")
			}
		}
		
		result.append(subSequence.joined())
		return result
	}
}


extension Character {
	var isUpperCase: Bool { return String(self) == String(self).uppercased() }
	var isLowerCase: Bool { return String(self) == String(self).lowercased() }
}
extension UnicodeScalar {
	var isUpperCase: Bool { return String(self) == String(self).uppercased() }
	var isLowerCase: Bool { return String(self) == String(self).lowercased() }
}

extension String {
	enum CaseBy {
		case upper
		case lower
	}
	
	
	func components(separatedBy:CaseBy = .upper) -> [String] {
		let charArray = Array(self)
		switch(separatedBy) {
		case .upper:
			return charArray.splitBefore(separator: { $0.isUpperCase })
		case .lower:
			return charArray.splitBefore(separator: { $0.isLowerCase })	//.map{String(describing: $0)}
		}
		//return [self]
	}
}

