//
// PageHelp.swift
//
// Generated by swagger-codegen
// Modified by dk (dk@devrock.co.kr)
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class PageHelp: BaseModel {
	// autogen apiList protocol
	static var apiList: [String: APIRequest] = PageHelp.buildApiRequests()


    public var content: [Help]?
    public var first: Bool?
    public var last: Bool?
    public var number: Int?
    public var numberOfElements: Int?
    public var size: Int?
    public var sort: Sort?
    public var totalElements: Int64?
    public var totalPages: Int?


    
    public init(content: [Help]?, first: Bool?, last: Bool?, number: Int?, numberOfElements: Int?, size: Int?, sort: Sort?, totalElements: Int64?, totalPages: Int?) {
        self.content = content
        self.first = first
        self.last = last
        self.number = number
        self.numberOfElements = numberOfElements
        self.size = size
        self.sort = sort
        self.totalElements = totalElements
        self.totalPages = totalPages
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(content, forKey: "content")
        try container.encodeIfPresent(first, forKey: "first")
        try container.encodeIfPresent(last, forKey: "last")
        try container.encodeIfPresent(number, forKey: "number")
        try container.encodeIfPresent(numberOfElements, forKey: "numberOfElements")
        try container.encodeIfPresent(size, forKey: "size")
        try container.encodeIfPresent(sort, forKey: "sort")
        try container.encodeIfPresent(totalElements, forKey: "totalElements")
        try container.encodeIfPresent(totalPages, forKey: "totalPages")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        content = try container.decodeIfPresent([Help].self, forKey: "content")
        first = try container.decodeIfPresent(Bool.self, forKey: "first")
        last = try container.decodeIfPresent(Bool.self, forKey: "last")
        number = try container.decodeIfPresent(Int.self, forKey: "number")
        numberOfElements = try container.decodeIfPresent(Int.self, forKey: "numberOfElements")
        size = try container.decodeIfPresent(Int.self, forKey: "size")
        sort = try container.decodeIfPresent(Sort.self, forKey: "sort")
        totalElements = try container.decodeIfPresent(Int64.self, forKey: "totalElements")
        totalPages = try container.decodeIfPresent(Int.self, forKey: "totalPages")
    }
}

