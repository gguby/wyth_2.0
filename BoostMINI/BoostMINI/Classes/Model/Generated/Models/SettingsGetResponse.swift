//
// SettingsGetResponse.swift
//
// Generated by swagger-codegen
// Modified by dk (dk@devrock.co.kr)
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class SettingsGetResponse: EasyCodable {


    public var alarm: Bool?
    public var selectedSkin: Int?
    public var skins: [Skin]?
    public var userName: String?


    
    public init(alarm: Bool?, selectedSkin: Int?, skins: [Skin]?, userName: String?) {
        self.alarm = alarm
        self.selectedSkin = selectedSkin
        self.skins = skins
        self.userName = userName
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(alarm, forKey: "alarm")
        try container.encodeIfPresent(selectedSkin, forKey: "selectedSkin")
        try container.encodeIfPresent(skins, forKey: "skins")
        try container.encodeIfPresent(userName, forKey: "userName")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        alarm = try container.decodeIfPresent(Bool.self, forKey: "alarm")
        selectedSkin = try container.decodeIfPresent(Int.self, forKey: "selectedSkin")
        skins = try container.decodeIfPresent([Skin].self, forKey: "skins")
        userName = try container.decodeIfPresent(String.self, forKey: "userName")
    }
}

