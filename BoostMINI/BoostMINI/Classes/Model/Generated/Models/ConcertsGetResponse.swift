//
// ConcertsGetResponse.swift
//
// Generated by swagger-codegen
// Modified by dk (dk@devrock.co.kr)
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class ConcertsGetResponse: BaseModel {
	// autogen apiList protocol
	static var apiList: [String: APIRequest] = ConcertsGetResponse.buildApiRequests()


    public var concertlist: [ConcertResponse]?


    
    public init(concertlist: [ConcertResponse]?) {
        self.concertlist = concertlist
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(concertlist, forKey: "concertlist")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        concertlist = try container.decodeIfPresent([ConcertResponse].self, forKey: "concertlist")
    }
}

