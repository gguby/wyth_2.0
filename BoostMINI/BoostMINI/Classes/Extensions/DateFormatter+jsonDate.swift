//
//  DateFormatter+jsonDate.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 15..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit

// .formatted(DateFormatter.jsonDate)
// json string에서 regex 돌려서 포맷이 있는쪽을 우선으로 돌리는게 성능은 더 나올 수 있다. 일단 yyyy-MM-dd'T'HH:mm:ss.SSS 로

extension DateFormatter {
	static let jsonDate: DateFormatter = {
		let formatter = DateFormatter()
		// ISO8601DateFormatter
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.timeZone = TimeZone(identifier: "KST")
		formatter.locale = Locale(identifier: "ko_KR")
		return formatter
	}()

	// 이게 표준이기떄문에 내부 변환시에는 이 포매터를 사용하게 됨
	static let jsonDate2: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		formatter.locale = Locale(identifier: "ko_KR")
		return formatter
	}()

	static let jsonDate3: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		formatter.locale = Locale(identifier: "ko_KR")
		return formatter
	}()
	
	static let jsonDate4: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		formatter.locale = Locale(identifier: "ko_KR")
		return formatter
	}()

}



