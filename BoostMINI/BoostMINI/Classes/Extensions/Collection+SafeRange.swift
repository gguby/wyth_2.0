//
//  Collection+SafeRange.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 22..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import Foundation

extension Collection {
	
	/// safe 인덱스로 값을 꺼내온다.
	/// 값이 없으면 nil이 반환됨. (out of index 방지)
	/// - Parameter index: 인덱스.
	/// c.f) let a = [1,2,3];  let b = a[safe:10] ?? 0;
	subscript (safe index: Index) -> Iterator.Element? {
		return indices.contains(index) ? self[index] : nil
	}
}

//extension Dictionary where Key: IntegerLiteralType { ... }
