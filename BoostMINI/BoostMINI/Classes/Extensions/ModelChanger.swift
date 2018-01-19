//
//  ModelChanger.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 19..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit

///  NoticeViewModel의 삭제와 관련해서 얘도 철거 위기에 놓임. 이미 파일명과 클래스명이 다른데 방치중.
class NoticeViewModel : EasyCodable {
	//static var apiList: [String : APIRequest]
	}
open class EasyCodable: Codable {
	
	/// 다른 모델에서 현재 모델로 변경
	open class func from<SRC: Encodable>(_ src: SRC) -> Self? {
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

	public init() {}
}
