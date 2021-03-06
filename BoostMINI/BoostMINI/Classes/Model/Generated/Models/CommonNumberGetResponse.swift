//
// CommonNumberGetResponse.swift
//
// Generated by swagger-codegen
// Modified by dk (dk@devrock.co.kr)
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class CommonNumberGetResponse: EasyCodable {


    public var skin: Skin?


    
    public init(skin: Skin?) {
        self.skin = skin
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(skin, forKey: "skin")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        skin = try container.decodeIfPresent(Skin.self, forKey: "skin")
    }
}

