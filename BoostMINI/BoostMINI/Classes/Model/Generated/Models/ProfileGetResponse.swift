//
// ProfileGetResponse.swift
//
// Generated by swagger-codegen
// Modified by dk (dk@devrock.co.kr)
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class ProfileGetResponse: EasyCodable {


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
    public var socialType: SocialType?


    
    public init(createdAt: Date?, email: String?, id: Int64?, name: String?, socialType: SocialType?) {
        self.createdAt = createdAt
        self.email = email
        self.id = id
        self.name = name
        self.socialType = socialType
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(createdAt, forKey: "createdAt")
        try container.encodeIfPresent(email, forKey: "email")
        try container.encodeIfPresent(id, forKey: "id")
        try container.encodeIfPresent(name, forKey: "name")
        try container.encodeIfPresent(socialType, forKey: "socialType")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        createdAt = try container.decodeIfPresent(Date.self, forKey: "createdAt")
        email = try container.decodeIfPresent(String.self, forKey: "email")
        id = try container.decodeIfPresent(Int64.self, forKey: "id")
        name = try container.decodeIfPresent(String.self, forKey: "name")
        socialType = try container.decodeIfPresent(SocialType.self, forKey: "socialType")
    }
}

