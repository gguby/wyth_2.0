//
//  CrashlyticsDestination.swift
//
//  Created by Jim Rutherford on 2015-12-10.
//
import UIKit
import SwiftyBeaver
import Crashlytics

public class CrashlyticsDestination: BaseDestination {
	
	override public var defaultHashValue: Int { return 3 }
	
	public override init() { super.init() }
		
	override public func send(_ level: SwiftyBeaver.Level, msg: String, thread: String,
					   file: String, function: String, line: Int, context: Any? = nil) -> String? {
		let formattedString = super.send(level, msg: msg, thread: thread,
										 file: file, function: function,
										 line: line, context: context)
		
		if let str = formattedString {
			CLSLogv("%@", getVaList([str]))
		}
		return formattedString
	}
}


