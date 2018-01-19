//
//  BoostProfile+Request.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 15..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import Foundation

extension BoostProfile {

	/// 토큰으로 로그인을 시도한다.
	///
	/// - Parameters:
	///   - token: 토큰
	///   - loginned: 부스트 가입이 되어 로그인이 성공한 사용자. Notifications 또는 클로져 블록으로 사용자 정보를 받고, 이는 이미 SessionHandler에 저장됨.
	///   - welcome: 부스트 가입이 안된 사용자. 환영한다는 웰컴이 아니다...웰컴페이지에 있는 약관동의가 필요하다는 의미이다. Notifications 또는 클로져 블록으로 이벤트를 받음.
	///   - failed: 완전 실패. 왜? 무엇때문에 왜때문에 와츠더메러윗유?!  대밋 클로이! Notifications 또는 클로져 블록으로 에러정보를 받고, 이는 이미 SessionHandler에 저장됨.
	static func login(_ token: String, loginned: ((BoostProfile?) -> Void)? = nil, welcome: (() -> Void)? = nil, failed: ((Error?) -> Void)? = nil) {
		
		// check 1
		SessionHandler.shared.token = token
		
		let pushToken = SessionHandler.shared.pushToken
		let osVersion = SessionHandler.shared.osVersion
		
		let block = {(data: AccountsPostResponse?, error: Error?) in
			BoostProfile
				.responseSignIn(data, error, loginned: { info in
					loginned?(info)
					NotificationCenter.default.post(name: BoostNotificationLogin.login.name, object: info)
				}, welcome: {
					welcome?()
					NotificationCenter.default.post(name: BoostNotificationLogin.needRegister.name, object: nil)
				}, failed: { error in
					failed?(error)
					NotificationCenter.default.post(name: BoostNotificationLogin.failed.name, object: error)
				})
		}
		
		DefaultAPI.signinUsingPOST(accessToken: token,
								   socialType: .smtown,
								   pushToken: pushToken,
								   osVersion: osVersion,
								   completion: block)
	}
	
	
	
	
	
	
	static func register(_ token: String, registered: ((BoostProfile?) -> Void)? = nil, failed: ((Error?) -> Void)? = nil) {
		guard let token = SessionHandler.shared.token else {
			BSTFacade.ux.showToast("TODO : token required")
			return
		}
		let pushToken = SessionHandler.shared.pushToken
		let osVersion = SessionHandler.shared.osVersion
		
		
		let block = {(data: AccountsPostResponse?, error: Error?) in
			BoostProfile
				.responseRegister(data, error, loginned: { info in
					registered?(info)
					NotificationCenter.default.post(name: BoostNotificationLogin.registered.name, object: info)
				}, failed: { error in
					failed?(error)
					NotificationCenter.default.post(name: BoostNotificationLogin.failed.name, object: error)
				})
		}
		
		DefaultAPI.signupUsingPOST(accessToken: token,
								   socialType: .smtown,
								   pushToken: pushToken,
								   osVersion: osVersion,
								   completion: block)
	}
}
