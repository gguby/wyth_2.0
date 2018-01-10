//
// ProfileGetResponse.swift
//
// Generated by swagger-codegen
// Modified by dk (dk@devrock.co.kr)
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class ProfileGetResponse: BaseModel {
	// autogen apiList protocol
	static var apiList: [String: APIRequest] = ProfileGetResponse.buildApiRequests()


    public enum SocialType: String, Codable { 
        case smtown = "SMTOWN"
        case facebook = "FACEBOOK"
        case twitter = "TWITTER"
        case google = "GOOGLE"
    }
    public var createdAt: Date?
    public var email: String?
    public var id: Int64?
    public var name: String?
    public var nationality: String?
    public var profilepicture: String?
    public var regdate: String?
    public var sex: String?
    public var socialType: SocialType?

    public init() {}

}
