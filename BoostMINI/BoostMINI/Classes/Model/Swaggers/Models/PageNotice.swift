//
// PageNotice.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class PageNotice: Codable {

    public var content: [Notice]?
    public var first: Bool?
    public var last: Bool?
    public var number: Int32?
    public var numberOfElements: Int32?
    public var size: Int32?
    public var sort: Sort?
    public var totalElements: Int64?
    public var totalPages: Int32?

    public init() {}

}
