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
    public var number: Int32?
    public var numberOfElements: Int32?
    public var size: Int32?
    public var sort: String?
    public var totalElements: Int64?
    public var totalPages: Int32?

    public init() {}

}
