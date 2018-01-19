//
// Notice.swift
//
// Generated by swagger-codegen
// Modified by dk (dk@devrock.co.kr)
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class Notice: BaseModel {
	// autogen apiList protocol
	static var apiList: [String: APIRequest] = Notice.buildApiRequests()


    public var content: String?
    public var id: Int64?
    public var title: String?


    
    public init(content: String?, id: Int64?, title: String?) {
        self.content = content
        self.id = id
        self.title = title
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(content, forKey: "content")
        try container.encodeIfPresent(id, forKey: "id")
        try container.encodeIfPresent(title, forKey: "title")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        content = try container.decodeIfPresent(String.self, forKey: "content")
        id = try container.decodeIfPresent(Int64.self, forKey: "id")
        title = try container.decodeIfPresent(String.self, forKey: "title")
    }
}

