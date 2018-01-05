//
// ProfileGetResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class ProfileGetResponse: BaseModel {

    public enum SocialType: String, Codable { 
        case smtown = "SMTOWN"
        case facebook = "FACEBOOK"
        case twitter = "TWITTER"
        case google = "GOOGLE"
    }
    public var createdAt: Date?
    public var email: String?
    public var id: Int64?
    public var socialType: SocialType?

    public init() {}

}