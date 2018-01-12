//
//  class functionHouse.swift
//  SMLightStick
//
//  Created by jack on 2017. 12. 18..
//  Copyright © 2017년 jack. All rights reserved.
//

import Foundation
import UIKit

// class ISNULL(_ obj: AnyObject?) -> Bool {
//	return (obj == nil || obj! is NSNull)
// }

class FunctionHouse {
//
//    class func BOOLSTR(_ b: Bool) -> String {
//        return (b ? "true" : "false")
//    }
//
//    class func STRBOOL(_ ss: String?) -> Bool {
//        guard let str = ss?.lowercased() else { return false }
//        let success = ["y", "yes", "t", "true", "on", "1"]
//        return success.contains(str)
//    }
//
//    class func REPORT_TIME() -> Int32 {
//        let v1 = Double(CFAbsoluteTimeGetCurrent()) * 1000.0
//        let v2 = div(Int32(v1), 3600).rem
//        print("\(v2)")
//        return v2
//    }
//
//    class func REPORT_TIME_WITHSTRING(_ name: String) -> Int32 {
//        let v1 = Double(CFAbsoluteTimeGetCurrent()) * 1000.0
//        let v2 = div(Int32(v1), 3600).rem
//        print("\(v2) - \(name)")
//        return v2
//    }
//
//    class func STRIP(_ X: String) -> String {
//        return X.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//    }
//
//    class func SAFE_ARRAY(_ obj: Any?) -> [Any] {
//        return dicOrArray(obj)
//    }
//
//    class func SAFE_DIC(_ obj: Any?) -> [AnyHashable: Any] {
//        return dicOnly(obj)
//    }
//
//    class func SAFE_DIC2(_ obj: Any?) -> [String: Any] {
//        return dicOnly(obj) as? [String: Any] ?? [:]
//    }
//
//    class func DIC_OR_ARRAY(_ obj: Any?) -> [Any] {
//        return dicOrArray(obj)
//    }
//
//    class func SAFE_STR(_ obj: Any?) -> String {
//        return obj as? String ?? ""
//    }
//
//    class func SAFE_BOOL(_ obj: Any?, _ def: Bool = false) -> Bool {
//        if obj == nil {
//            return def
//        }
//        return STRBOOL(SAFE_STR(obj))
//    }
//
//    class func SAFE_INT(_ obj: Any?) -> Int {
//        if obj == nil {
//            return 0
//        }
//        if let n = obj as? Int {
//            return n
//        }
//        if let ns = obj as? NSNumber {
//            return ns.intValue
//        }
//
//        let s = SAFE_STR(obj)
//        if let no = Int(s) {
//            return no
//        }
//        return 0
//    }
//
//    public class func runInNextMainThread(_ f: @escaping () -> Swift.Void) {
//        DispatchQueue.main.async {
//            f()
//        }
//    }
//
//    public class func runInNextMainThread(withDelay: TimeInterval, _ f: @escaping () -> Swift.Void) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + withDelay) {
//            f()
//        }
//    }
//
//    /// 자동 지역화 스트링 (LocalizedString)
//    public class func _T(_ key: String) -> String {//T
//        // QL4(key)
//        return NSLocalizedString(key, comment: "[\(key)]")
//    }
//
//    /// 논리 반전
//    public class func not(_ val: Bool) -> Bool {
//        return !val
//    }
//
//    class func unwrap(_ any: Any) -> Any {
//
//        let mi = Mirror(reflecting: any)
//        if mi.displayStyle != .optional {
//            return any
//        }
//
//        if mi.children.count == 0 { return NSNull() }
//        let (_, some) = mi.children.first!
//        return some
//    }
//
//    public class func ss(_ any: Any?) -> String {
//        if any == nil {
//            return ""
//        }
//        return ss(any!)
//    }
//
//    public class func ss(_ any: Any) -> String {
//
//        let v = unwrap(any) // Any? 아니고 Any라서그런지.. 안먹힌다 제대로
//        return s("\(v)")
//    }
//
//    public class func s(_ val: String?) -> String {
//        if val == nil { return "" }
//        if val!.isEmpty { return "" }
//        var result = val!
//        if not(result.isEmpty) && result.hasPrefix("Optional:(") && result.hasSuffix(")") {
//            let idx1 = result.index(result.startIndex, offsetBy: "Optional:(".count)
//            let idx2 = result.index(result.endIndex, offsetBy: -1) // ")"
//            result = String(result[idx1 ..< idx2])
//        }
//        return result
//    }
//
//    /// ""도 nil 로 바꿔줌.
//    public class func ss_etn(_ v: String?) -> String? {
//        return (v == nil || v!.isEmpty) ? nil : v
//    }
//
//    @discardableResult
//    class func OPEN_SAFARI(_ urlString: String) -> Bool {
//        return UIApplication.shared.openURL(URL(string: urlString)!)
//    }
//
//    class func dicOrArray(_ obj: Any?) -> [Any] {
//        guard let obj = obj else {
//            return [Any]()
//        }
//        if let dic = obj as? [AnyHashable: Any] {
//            return [dic]
//        }
//        if let arr = obj as? [Any] {
//            return arr
//        }
//
//        if let str = obj as? String {
//            var dic: [AnyHashable: Any] = [:]
//            dic[str] = str
//            return [dic]
//        }
//        return [Any]()
//    }
//
//    class func dicOnly(_ obj: Any?) -> [AnyHashable: Any] {
//        guard let obj = obj else {
//            return [AnyHashable: Any]()
//        }
//
//        if let dic = obj as? [AnyHashable: Any] {
//            return dic
//        }
//        if let arr = obj as? [Any] {
//            if arr.count == 0 {
//                return [AnyHashable: Any]()
//            }
//            let first = arr[0]
//            if let dic = first as? [AnyHashable: Any] {
//                return dic
//            }
//            var dic = [AnyHashable: Any]()
//            dic["data"] = arr.count == 1 ? first : arr
//
//            return dic
//        }
//        return ["data": obj]
//    }
//
//    class func autocast<T>(some: Any) -> T? {
//        return some as? T
//    }
//
}
