//
// NoticesGetResponse.swift
//
// Generated by swagger-codegen
// Modified by dk (dk@devrock.co.kr)
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class NoticesGetResponse: BaseModel {
	// autogen apiList protocol
	static var apiList: [String: APIRequest] = NoticesGetResponse.buildApiRequests()


    public var list: PageNotice?

    public init() {}

}
