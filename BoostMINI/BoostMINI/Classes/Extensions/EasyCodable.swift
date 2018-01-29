//
//  ModelChanger.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 19..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import ObjectiveC

protocol EasyCodable: Codable {
}

extension EasyCodable {
	
	/// 다른 모델에서 현재 모델로 변경
	static func from<SRC: Encodable>(_ src: SRC) -> Self? {
		let enc = CodableHelper.encode(src)
		guard let data = enc.data else {
			return nil
		}
		let dec = CodableHelper.decode(self, from: data)
		return dec.decodableObj
	}

	/// 현재 모델을 다른 모델로 변경
	func convert<DESC: Decodable>() -> DESC? {
		let enc = CodableHelper.encode(self)
		guard let data = enc.data else {
			return nil
		}
		let dec = CodableHelper.decode(DESC.self, from: data)
		return dec.decodableObj
	}
	

	func toJson() -> String {
		do {
			let jsonData = try JSONEncoder.base.encode(self)
			let jsonString = String(data: jsonData, encoding: .utf8)
			return jsonString ?? ""
		} catch {
		}
		
		return ""
	}

	
}


private var AssociationExpandKey: String = "expandKey"
extension EasyCodable {
	
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

