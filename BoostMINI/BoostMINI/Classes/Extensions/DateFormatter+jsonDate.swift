//
//  DateFormatter+jsonDate.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 15..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit

// .formatted(DateFormatter.jsonDate)

extension DateFormatter {
	static let jsonDate: DateFormatter = {
		let formatter = DateFormatter()
		// ISO8601DateFormatter
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.timeZone = TimeZone(identifier: "KST")
		//formatter.timeZone = TimeZone(secondsFromGMT: 0)
		formatter.locale = Locale(identifier: "ko_KR") // "en_US_POSIX")
		return formatter
	}()

	// createAt 등등
	static let jsonDate2: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		formatter.calendar = Calendar(identifier: .iso8601)
		//formatter.timeZone = TimeZone(identifier: "KST")
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		formatter.locale = Locale(identifier: "ko_KR") // "en_US_POSIX")
		return formatter
	}()

}



