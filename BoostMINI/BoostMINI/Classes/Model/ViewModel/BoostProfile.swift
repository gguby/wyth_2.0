//
//  BoostProfile.swift
//  BoostMINI
//
//  얘를 ViewModel 이라고 구분은 해 놓았지만, View에 의존적이지는 않음...
//
//  Created by jack on 2018. 1. 11..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//
import Foundation

/// 사용자 정보 관련.
open class BoostProfile: EasyCodable {
	
	public var createdAt: Date?
	public var email: String = ""
	public var id: Int64 = 0
	public var name: String = ""
	public var nationality: String?
	public var profilePicture: String?
	public var regDate: String?
	public var sex: String?
	public var socialType: BoostSocialType?
	
	public init() {}
	
}

public enum BoostSocialType: String, Codable {
	case smtown = "SMTOWN"
	case facebook = "FACEBOOK"
	case twitter = "TWITTER"
	case google = "GOOGLE"
}


