//
//  LogManager.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 21..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//
import Foundation
import UIKit
import SwiftyBeaver
//import Crashlytics

enum LogManagerType: Int {
	case swiftyBeaver = 0
	case cleanLoom
	case crashlytics
}

enum LogType: Int {
	case verbose = 0	// trash logs for instance debugging.
	case debug			// debug log
	case log			// normal log				(visible in release mode)
	case warning		// warning level log 		(visible in release mode)
	case error			// crash error level log	(visible in release mode)
}

