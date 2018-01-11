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

	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}

	
	
	func testLog() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

		// , LogDestination.beaverCloud
		for x in [LogDestination.none, LogDestination.console, LogDestination.crashlytics] {
			print(".none = %d, %d (defaultHash:%d)".format(x.rawValue, x.hashValue, x.defaultHashValue))
		}

		self.measure {
			logVerbose("test console (default)")
		}

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
	
	// 코더블 모델 변환이 두려우시다면 요 테스트를 보고, 믿으세요!~
	func testProfileGetResponse() throws {
		self.measure {
			
			let v1 = ProfileGetResponse()
			v1.id = 1
			v1.name = "홍길dong"
			v1.email = "a@b.c"
			
			v1.createdAt = Date(timeIntervalSinceNow: -999)
			v1.nationality = "ko"
			v1.profilepicture = "http://blahblah"
			v1.regdate = nil
			v1.sex = "철9"
			v1.socialType = .smtown

			let v2 = BoostProfile.from(v1)!
			
			print("ProfileGetResponse -> BoostProfile")
			
			print(v1)
			print(v2)

			// v2: BoostProfile(any encodable model) -> enc.data (json or whatever)
			let enc = CodableHelper.encode(v2)
			// enc.data -> dec.decodableObj (ProfileGetResponse or any decodable model)
			let dec = CodableHelper.decode(ProfileGetResponse.self, from: enc.data!)
			var v3 = dec.decodableObj as! ProfileGetResponse	// 변환 실패시 nil

			XCTAssertEqual(v1.name, v2.name)
			XCTAssertEqual(v2.name, v3.name)
			
			XCTAssertEqual(v1.id, v3.id)
			
			XCTAssertEqual(v1.email, v3.email)
			
			XCTAssertEqual(v1.profilepicture, v2.profilepicture)
			XCTAssertEqual(v2.profilepicture, v3.profilepicture)

			XCTAssertEqual(v1.createdAt, v3.createdAt)
			XCTAssertEqual(v2.createdAt, v3.createdAt)

		}
	}
	
	func testAccountsPostResponse() throws {
		self.measure {
			let v1 = AccountsPostResponse()
			v1.id = 1
			v1.name = "홍길dong"
			v1.email = "a@b.c"
			
			v1.createdAt = Date(timeIntervalSinceNow: -999)
			v1.nationality = "ko"
			v1.profilepicture = "http://blahblah"
			v1.regdate = nil
			v1.sex = "철9"
			v1.socialType = .smtown

			let v2 = BoostProfile.from(v1)!
			
			print("AccountsPostResponse -> BoostProfile")
			
			print(v1)
			print(v2)
			
			let enc = CodableHelper.encode(v2)
			let dec = CodableHelper.decode(AccountsPostResponse.self, from: enc.data!)
			var r1 = dec.decodableObj as! AccountsPostResponse
		}
	}
	
	func testFailAccountsPostResponse() throws {
		self.measure {
			let v1 = AccountsPostResponse()
			v1.id = 1
			v1.name = nil		// BoostProfile 에는 Optional 이 없으므로 오류가 나야 함.
			v1.email = "a@b.c"
			
			v1.createdAt = Date(timeIntervalSinceNow: -999)
			v1.nationality = "ko"
			v1.profilepicture = "http://blahblah"
			v1.regdate = nil
			v1.sex = "철9"
			v1.socialType = .smtown
			
			var v2: BoostProfile!
			v2 = BoostProfile.from(v1)	// try로는 안잡히고 nil이 떨어짐.
		
			
			// 변환을 굳이 하려면
			XCTAssertNil(v2)
		}
	}

}
