////
////  TestModel.swift
////  BoostMINI
////
////  Created by jack on 2017. 12. 29..
////  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
////
//
//import Foundation
//import Alamofire
//
//class AppVersionModel : BaseModel {
//	
//	static var apiList: [String: APIRequest] {
//		return APIRequest("common/app/update",
//						 .get,
//						 ["deviceType":"ios",
//						  "current":appVersionStatic],
//						 isArrayResult: false).asGroup()
//	}
//	private static var appVersionStatic: String = BSTConstants.main.appVersion
//	let appVersion: String = BSTConstants.main.appVersion
//	let serverVersion: String
//	
//	private enum CodingKeys: String, CodingKey {
//		case serverVersion = "version"
//	}
//}
//
//// usage :	AppVersionModel.get { block in
//// 				if block.isSucceed {
////					print(block.data!.serverVersion)
////				}
////			}
//
//// usage :	AppVersionModel.get(["type":"ios"]) { block in
//// 				if block.isSucceed {
////					print(block.data!.serverVersion)
////				}
////			}
//
//
//extension AppVersionModel {
//
//	var description: String {	// DEBUGGING ONLY
//		return "Version : \(serverVersion) /, current : \(appVersion), updateNeeded: \(isNeedUpdate), forceupdate: \(isForceUpdate)"
//	}
//
//	var isNeedUpdate: Bool {
//		// TODO:
//		return false
//	}
//	var isForceUpdate: Bool {
//		// TODO:
//		return false
//	}
//	
//
//}

