//
//  OptionSet+Sequence.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 21..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import Foundation

public extension OptionSet where RawValue: FixedWidthInteger {
	
	func elements() -> AnySequence<Self> {
		var remainingBits = rawValue
		var bitMask: RawValue = 1
		return AnySequence {
			return AnyIterator {
				while remainingBits != 0 {
					defer { bitMask = bitMask &* 2 }
					if remainingBits & bitMask != 0 {
						remainingBits = remainingBits & ~bitMask
						return Self(rawValue: bitMask)
					}
				}
				return nil
			}
		}
	}
}
