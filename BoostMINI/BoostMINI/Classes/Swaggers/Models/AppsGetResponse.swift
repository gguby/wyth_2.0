//
// AppsGetResponse.swift
//
// Generated by swagger-codegen
// Modified by dk (dk@devrock.co.kr)
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class AppsGetResponse: BaseModel {
	// autogen apiList protocol
	static var apiList: [String: APIRequest] = AppsGetResponse.buildApiRequests()


    public var forceUpdate: Bool?
    public var id: Int64?
    public var version: String?

    public init() {}

}