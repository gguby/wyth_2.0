//
// Skin.swift
//
// Generated by swagger-codegen
// Modified by dk (dk@devrock.co.kr)
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class Skin: BaseModel {
	// autogen apiList protocol
	static var apiList: [String: APIRequest] = Skin.buildApiRequests()


    public var id: Int64?
    public var select: Bool?
    public var url: String?

    public init() {}

}