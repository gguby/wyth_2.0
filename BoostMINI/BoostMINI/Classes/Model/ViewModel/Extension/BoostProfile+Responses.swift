//
//  BoostProfile+Responses.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 15..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import Foundation

extension BoostProfile {
	
	/// 헷깔린다. 서버 api 설명으로는 부족하고, 계정 3개 만들어서 여러가지 케이스를 체크해보고있는데 헷깔린다... 그림이나 설명을 좀 제대로 해줬으면 좋겠는데...
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
				// 토큰 만료.			// 존재하지않는 토큰... (404 나왔었던것같은데...)
				failed(error)		// APIError에 906 없음...
				
			case 960:
				// smtown 가족이지만 가입 안된 케이스
				welcome()
				
			default:
				// 에라 모르겠다
				welcome()
			}
			return
		}
		
		if let err = error {
			if let err = err as? BSTError {
				switch err {
				case .api(let ae):
					if ae.rawValue == 404 {
						//					// ???
						//
						//					doSignUp()
						//					return
					}
				default:
					break
				}
			} else {
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
	
	
	

	// 애는 뭐, 특별한오류가 없으면, 회원 가입은 된 것이라 보여진다.
	internal static func responseRegister(_ data: AccountsPostResponse?,
										_ error: Error?,
										loginned: ((BoostProfile?) -> Void),
										failed: ((Error?) -> Void)) {
		logVerbose("\(#function) - \(error)")
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
			// cook? or nothing?
			// cook을 반드시 해야 하는가? 이미 해서 넘어온것인지는 어떻게 구분하는가? 안하고 넘기면 다음에 어떤 일이 발생하는가? 이러한 범위는 어떻게 정의되는가?
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

