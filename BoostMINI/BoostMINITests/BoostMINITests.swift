//
//  BoostMINITests.swift
//  BoostMINITests
//
//  Created by HS Lee on 12/12/2017.
//  Copyright © 2017 IRIVER LIMITED. All rights reserved.
//

import XCTest
@testable import BoostMINI

class BoostMINITests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

		
		for x in [LogDestination.none, LogDestination.console, LogDestination.beaverCloud, LogDestination.crashlytics] {
			print(".none = %d, %d (defaultHash:%d)".format(x.rawValue, x.hashValue, x.defaultHashValue))
		}

		logVerbose("test console (default)")

		Logger.destination = .console
		logDebug("test console1 (c)")

		Logger.destination = [.console, .file]
		logWarning("test console2 (c+f)")

		Logger.destination = [.file]
		logDebug("test console3 (f)")

		Logger.destination = .console
		logDebug("test console4 (c)")

		for level in [LogLevel.debug, .warning, .error, .verbose] {
			Logger.setMinLogLevel(level)
			logVerbose("verbose")
			logDebug("debug")
			logInfo("info")
			logWarning("warning")
			logError("error")
		}
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
