//
//  NilDestination.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 22..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import UIKit
import SwiftyBeaver
import Crashlytics

public class NilDestination: BaseDestination {
	override public var defaultHashValue: Int { return 0 }
	
	public override init() {
		super.init()
		format = ""
		
	}
	
	override public func send(_ level: SwiftyBeaver.Level, msg: String, thread: String,
							  file: String, function: String, line: Int, context: Any? = nil) -> String? {
		return nil
	}
}


