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
    /// - 예: (LogManager 참고)
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
