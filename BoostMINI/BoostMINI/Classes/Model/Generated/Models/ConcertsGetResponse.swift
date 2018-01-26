//
// ConcertsGetResponse.swift
//
// Generated by swagger-codegen
// Modified by dk (dk@devrock.co.kr)
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class ConcertsGetResponse: EasyCodable {


    public var concertlist: [ConcertResponse]?
    public var totalAlarm: Int?


    
    public init(concertlist: [ConcertResponse]?, totalAlarm: Int?) {
        self.concertlist = concertlist
        self.totalAlarm = totalAlarm
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(concertlist, forKey: "concertlist")
        try container.encodeIfPresent(totalAlarm, forKey: "totalAlarm")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        concertlist = try container.decodeIfPresent([ConcertResponse].self, forKey: "concertlist")
        totalAlarm = try container.decodeIfPresent(Int.self, forKey: "totalAlarm")
    }
}

