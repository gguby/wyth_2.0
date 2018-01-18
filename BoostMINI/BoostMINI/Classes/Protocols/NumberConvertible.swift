//
//  NumberConvertible.swift
//  BoostMINI
//
//  Created by HS Lee on 21/12/2017.
//  Copyright © 2017 IRIVER LIMITED. All rights reserved.
//
import CoreGraphics // For CGFloat
import Foundation

public typealias PreferredType = Double

public protocol NumberConvertible: Comparable {
    init(_ value: Int)
    init(_ value: Float)
    init(_ value: Double)
    init(_ value: CGFloat)
    init(_ value: UInt8)
    init(_ value: Int8)
    init(_ value: UInt16)
    init(_ value: Int16)
    init(_ value: UInt32)
    init(_ value: Int32)
    init(_ value: UInt64)
    init(_ value: Int64)
    init(_ value: UInt)
}

public protocol IntNumberConvertible: NumberConvertible {
    static var max: Self { get }
}

extension CGFloat {
    public init(_ value: CGFloat) {
        self.init(Double(value))
    }
}

extension NumberConvertible {

    fileprivate func convert<T: NumberConvertible>() -> T {
        switch self {
        case let x as CGFloat:
            return T(x)
        case let x as Float:
            return T(x)
        case let x as Int:
            return T(x)
        case let x as Double:
            return T(x)
        case let x as UInt8:
            return T(x)
        case let x as Int8:
            return T(x)
        case let x as UInt16:
            return T(x)
        case let x as Int16:
            return T(x)
        case let x as UInt32:
            return T(x)
        case let x as Int32:
            return T(x)
        case let x as UInt64:
            return T(x)
        case let x as Int64:
            return T(x)
        case let x as UInt:
            return T(x)
        default:
            assert(false, "NumberConvertible convert cast failed!")
            return T(0)
        }
    }

    public var c: CGFloat { return convert() }

    public var f: Float { return convert() }

    public var d: Double { return convert() }

    public var i: Int { return convert() }
    
    public var i32: Int32 { return convert() }
    
    public var i64: Int64 { return convert() }

    public var u: UInt { return convert() }

    public var s: String {
        return "\(self)"
    }

    public var ns: NSNumber {
        return (self as? NSNumber)!
    }

    public func sZ(_ count: Int = 4) -> String { /// 4 -> "0004",   23 -> "0023"
        return sN(count, "0")
    }

    public func sN(_ count: Int = 4, _: String = " ") -> String { // 11 ->  "  11",  0 -> "   0"
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = count
        let m = formatter.string(from: ns) ?? "\(self)"
        return m
    }
}

extension CGFloat: NumberConvertible {}
extension Double: NumberConvertible {}
extension Float: NumberConvertible {}
extension Int: IntNumberConvertible {}
extension UInt8: IntNumberConvertible {}
extension Int8: IntNumberConvertible {}
extension UInt16: IntNumberConvertible {}
extension Int16: IntNumberConvertible {}
extension UInt32: IntNumberConvertible {}
extension Int32: IntNumberConvertible {}
extension UInt64: IntNumberConvertible {}
extension Int64: IntNumberConvertible {}
extension UInt: IntNumberConvertible {}

// MARK: - Assignment overloading -

extension NumberConvertible {

    fileprivate typealias CombineType = (PreferredType, PreferredType) -> PreferredType

    fileprivate func operate<T: NumberConvertible, V: NumberConvertible>(_ b: T, combine: CombineType) -> V {
        let x: PreferredType = convert()
        let y: PreferredType = b.convert()
        return combine(x, y).convert()
    }
}

public func + <T: NumberConvertible, U: NumberConvertible, V: NumberConvertible>(lhs: T, rhs: U) -> V {
    return lhs.operate(rhs, combine: +)
}

public func - <T: NumberConvertible, U: NumberConvertible, V: NumberConvertible>(lhs: T, rhs: U) -> V {
    return lhs.operate(rhs, combine: -)
}

public func * <T: NumberConvertible, U: NumberConvertible, V: NumberConvertible>(lhs: T, rhs: U) -> V {
    return lhs.operate(rhs, combine: *)
}

public func / <T: NumberConvertible, U: NumberConvertible, V: NumberConvertible>(lhs: T, rhs: U) -> V {
    return lhs.operate(rhs, combine: /)
}

public func % <T: NumberConvertible, U: NumberConvertible, V: NumberConvertible>(lhs: T, rhs: U) -> V {
    return lhs.operate(rhs, combine: %)
}

// MARK: -

/// Use `?=` for assignment to already previously defined number types (non-`Double`)
// infix operator ?= { associativity right precedence  90 assignment}

// func ?= <T:NumberConvertible, U:NumberConvertible>( lhs: inout T, rhs: U){
//    lhs = rhs.convert()
// }

// For values not previously assigned use the `^^` operator
// (number with desired type) `^^` (arithmetic operation)

// infix operator ^^ { precedence  100 }

// func ^^ <T:NumberConvertible, U:NumberConvertible>( lhs: T, rhs: U) -> T{
//
//    var lhs = lhs
//    lhs = rhs.convert()
//    let x:T = rhs.convert()
//    return x;
// }

// MARK: - Equatable+Comparable overloading -

public func == <T: NumberConvertible, U: NumberConvertible>(lhs: T, rhs: U) -> Bool {
    let v: PreferredType = lhs.convert()
    let w: PreferredType = rhs.convert()
    return v == w
}

public func != <T: NumberConvertible, U: NumberConvertible>(lhs: T, rhs: U) -> Bool {
    let v: PreferredType = lhs.convert()
    let w: PreferredType = rhs.convert()
    return v != w
}

public func >= <T: NumberConvertible, U: NumberConvertible>(lhs: T, rhs: U) -> Bool {
    let v: PreferredType = lhs.convert()
    let w: PreferredType = rhs.convert()
    return v >= w
}

public func > <T: NumberConvertible, U: NumberConvertible>(lhs: T, rhs: U) -> Bool {
    let v: PreferredType = lhs.convert()
    let w: PreferredType = rhs.convert()
    return v > w
}

public func <= <T: NumberConvertible, U: NumberConvertible>(lhs: T, rhs: U) -> Bool {
    let v: PreferredType = lhs.convert()
    let w: PreferredType = rhs.convert()
    return v <= w
}

public func < <T: NumberConvertible, U: NumberConvertible>(lhs: T, rhs: U) -> Bool {
    let v: PreferredType = lhs.convert()
    let w: PreferredType = rhs.convert()
    return v < w
}

// MARK: - Overflow Checking -

/// wouldOverflowResult
/// result: **number with expected result type**
///      x: **arithmetic operation**
/// `true` = overflows, `false` = safe operation

func wouldOverflowResult<T: IntNumberConvertible, U: NumberConvertible>(result _: T, _ x: U) -> Bool {
    let max: Double = T.max.convert()
    let test: Double = x.convert()

    if test > max {
        return true
    }
    return false
}
