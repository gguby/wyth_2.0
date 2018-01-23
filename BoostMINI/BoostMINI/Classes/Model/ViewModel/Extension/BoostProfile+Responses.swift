//
//  BoostProfile+Responses.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 15..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import Foundation

extension BoostProfile {
	
	internal static func responseSignIn(_ data: AccountsPostResponse?,
									   _ error: Error?,
									   loginned: ((BoostProfile?) -> Void),
									   welcome: (() -> Void),
									   failed: ((Error?) -> Void)) {
		logVerbose("\(#function) - \(error)")
		if let code = BSTErrorTester.checkWhiteCode(error) {
			switch(code) {
			case 201:
				welcome()
				
			case 906:
				// 토큰 만료.		// 존재하지않는 토큰... (404 나왔었던것같은데... 일단 무시. 관련코드도 제거.)
				failed(error)	// APIError에 906 없음...
				
			case 960:
				// smtown 가족이지만 가입 안된 케이스
				welcome()
				
			default:
				welcome()
			}
			return
		}
		
		if let err = error {
			if let err = err as? BSTError {
				logVerbose("\(err)")
			} else {
				logError("\(err)")
				BSTFacade.ux.showToastError(err.localizedDescription)
			}
			failed(err)
			
		}
		
		
		
		guard let token = SessionHandler.shared.token,
			let info = data else {
				logVerbose("nil data")
				failed(BSTError.nilError)
				return
		}
		
		
		let profile = BoostProfile.from(info)
		SessionHandler.shared.setSession(token, profile)
		
		loginned(BoostProfile.from(data))
	}
	
	
	

	internal static func responseRegister(_ data: AccountsPostResponse?,
										_ error: Error?,
										loginned: ((BoostProfile?) -> Void),
										failed: ((Error?) -> Void)) {
		logVerbose("\(#function) - \(error?.localizedDescription ?? "")")
		if let code = BSTErrorTester.checkWhiteCode(error) {
			logVerbose("\(#function) - white #\(code)")
			if let profile = BoostProfile.from(data) {
				loginned(profile)
			} else {
				failed(BSTError.convertError)
			}
			return
			
		}
		
		if let err = error as? BSTError {
			failed(err)
			return
		}
		
		guard let profile = BoostProfile.from(data) else {
			failed(BSTError.convertError)
			return
		}
		
		loginned(profile)
	}
	
	
}

