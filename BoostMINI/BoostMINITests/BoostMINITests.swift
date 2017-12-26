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
//
//		LogManager.log("test console (default)")
//
//		LogManager.destination = .console
//		LogManager.log("test console1 (c)")
//
//		LogManager.destination = [.console, .file]
//		LogManager.log("test console2 (c+f)")
//
//		LogManager.destination = [.file]
//		LogManager.log("test console3 (f)")
//
//		LogManager.destination = .console
//		LogManager.log("test console4 (c)")

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
