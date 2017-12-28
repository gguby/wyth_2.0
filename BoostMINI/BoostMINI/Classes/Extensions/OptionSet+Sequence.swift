//
//  OptionSet+Sequence.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 21..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import Foundation

public extension OptionSet where RawValue: FixedWidthInteger {

    /// OptionSet을 사용한 enum에서 각 항목들을 시퀀셜하게 변환해줌. (반복문 사용 가능)
    ///
    /// - 예: (Logger 참고)
    /// 	let options: enumCustomOptions
    /// 	for item in options { let raw = item.rawValue; ... }
    ///
    ///
    /// - Returns: AnySequence<Self>
    func elements() -> AnySequence<Self> {
        var remainingBits = rawValue
        var bitMask: RawValue = 1
        return AnySequence {
            AnyIterator {
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


public protocol EnumCollection: Hashable {
	static func cases() -> AnySequence<Self>
	static var allValues: [Self] { get }
}

public extension EnumCollection {

	
	/// 일반 enum에서 모든 항목을 시퀀스로 반환.
	public static func cases() -> AnySequence<Self> {
		return AnySequence { () -> AnyIterator<Self> in
			var raw = 0
			return AnyIterator {
				let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
				guard current.hashValue == raw else {
					return nil
				}
				raw += 1
				return current
			}
		}
	}
	
	public static var allValues: [Self] {
		return Array(self.cases())
	}
}
