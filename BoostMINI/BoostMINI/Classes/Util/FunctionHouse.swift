//
//  FunctionHouse.swift
//  SMLightStick
//
//  Created by jack on 2017. 12. 18..
//  Copyright © 2017년 jack. All rights reserved.
//

import Foundation

//func ISNULL(_ obj: AnyObject?) -> Bool {
//	return (obj == nil || obj! is NSNull)
//}

func BOOLSTR(_ b: Bool) -> String {
	return (b ? "true" : "false")
}
func STRBOOL(_ ss: String?) -> Bool {
	guard let str = ss?.lowercased() else { return false }
	let success = ["y","yes", "t","true", "on", "1"]
	return success.contains(str)
}


func REPORT_TIME() -> Int32 {
	let v1 = Double(CFAbsoluteTimeGetCurrent()) * 1000.0
	let v2 = div(Int32(v1), 3600).rem
	print("\(v2)")
	return v2
}
func REPORT_TIME_WITHSTRING(_ name: String) -> Int32 {
	let v1 = Double(CFAbsoluteTimeGetCurrent()) * 1000.0
	let v2 = div(Int32(v1), 3600).rem
	print("\(v2) - \(name)")
	return v2
}

func STRIP(_ X: String) -> String {
	return X.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
}

func SAFE_ARRAY(_ obj: Any?) -> [Any] {
	return dicOrArray(obj)
}
func SAFE_DIC(_ obj: Any?) -> [AnyHashable:Any] {
	return dicOnly(obj)
}

func SAFE_DIC2(_ obj: Any?) -> [String:Any] {
	return dicOnly(obj) as? [String:Any] ?? [:]
}

func DIC_OR_ARRAY(_ obj: Any?) -> [Any] {
	return dicOrArray(obj)
}

func SAFE_STR(_ obj: Any?) -> String {
	return obj as? String ?? ""
}

func SAFE_BOOL(_ obj:Any?, _ def:Bool = false) -> Bool {
	if obj == nil {
		return def
	}
	return STRBOOL(SAFE_STR(obj))
}

func SAFE_INT(_ obj:Any?) -> Int {
	if obj == nil {
		return 0
	}
	if let n = obj as? Int {
		return n
	}
	if let ns = obj as? NSNumber {
		return ns.intValue
	}
	
	let s = SAFE_STR(obj)
	if let no = Int(s) {
		return no
	}
	return 0
}

public func RunInNextMainThread(_ f: @autoclosure @escaping () -> Swift.Void) {
	DispatchQueue.main.async {
		f()
	}
}

public func RunInNextMainThread(withDelay:TimeInterval, _ f: @autoclosure @escaping () -> Swift.Void ) {
	DispatchQueue.main.asyncAfter(deadline: .now() + withDelay) {
		f()
	}
}



/// 자동 지역화 스트링 (LocalizedString)
public func _T(_ key: String) -> String {
	//QL4(key)
	return NSLocalizedString(key, comment: "[\(key)]")
}

/// 논리 반전
public func not(_ val:Bool) -> Bool {
	return !val
}


func unwrap(_ any:Any) -> Any {
	
	let mi = Mirror(reflecting: any)
	if mi.displayStyle != .optional {
		return any
	}
	
	if mi.children.count == 0 { return NSNull() }
	let (_, some) = mi.children.first!
	return some
}


public func ss(_ any:Any?) -> String {
	if any == nil {
		return ""
	}
	return ss(any!)
}

public func ss(_ any:Any) -> String {
	
	let v = unwrap(any) // Any? 아니고 Any라서그런지.. 안먹힌다 제대로
	return s("\(v)")
	
}

public func s(_ val:String?) -> String {
	if (val == nil) { return "" }
	if val!.isEmpty { return "" }
	var result = val!
	if not(result.isEmpty) && result.hasPrefix("Optional:(") && result.hasSuffix(")") {
		let idx1 = result.index(result.startIndex, offsetBy: "Optional:(".count)
		let idx2 = result.index(result.endIndex, offsetBy: -1) // ")"
		result = String(result[idx1..<idx2])
	}
	return result
}


/// ""도 nil 로 바꿔줌.
public func ss_etn(_ v:String?) -> String? {
	return (v == nil || v!.isEmpty) ? nil : v
}

enum RxError:Error {
	case isEmpty
	case argumentError
	case nilError
	case unknown
}




func dicOrArray(_ obj: Any?) -> [Any] {
	guard let obj = obj else {
		return [Any]()
	}
	if let dic = obj as? [AnyHashable: Any] {
		return [dic]
	}
	if let arr = obj as? [Any] {
		return arr
	}
	
	if let str = obj as? String{
		var dic:[AnyHashable:Any] = [:]
		dic[str] = str
		return [dic]
	}
	return [Any]()
}

func dicOnly(_ obj: Any?) -> [AnyHashable: Any] {
	guard let obj = obj else {
		return [AnyHashable:Any]()
	}
	
	if let dic = obj as? [AnyHashable: Any] {
		return dic
	}
	if let arr = obj as? [Any] {
		if arr.count == 0 {
			return [AnyHashable:Any]()
		}
		let first = arr[0]
		if let dic = first as? [AnyHashable:Any] {
			return dic
		}
		var dic = [AnyHashable:Any]()
		dic["data"] = arr.count == 1 ? first : arr
		
		return dic
	}
	return ["data": obj]
	
}
