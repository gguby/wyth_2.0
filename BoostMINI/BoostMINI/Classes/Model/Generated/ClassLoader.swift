//
// ClassLoader.swift
//
// Generated by swagger-codegen
// Modified by dk (dk@devrock.co.kr)
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire


open class ClassLoader: BaseModel {
	// autogen apiList protocol
	static var apiList: [String: APIRequest] = ClassLoader.buildApiRequests()


    public var parent: ClassLoader?

    public init() {}

}
