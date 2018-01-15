//
// CodableHelper.swift
//
// Generated by swagger-codegen
// Modified by dk (dk@devrock.co.kr)
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

public typealias EncodeResult = (data: Data?, error: Error?)

open class CodableHelper {

    open class func decode<T>(_ type: T.Type, from data: Data) -> (decodableObj: T?, error: Error?) where T : Decodable {
        var returnedDecodable: T? = nil
        var returnedError: Error? = nil

        let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .formatted(DateFormatter.jsonDate)	 // It is necessary for correct decoding. Timestamp -> Date.
		//	decoder.dataDecodingStrategy = .base64
		//	if #available(iOS 10.0, *) {
		//		decoder.dateDecodingStrategy = .iso8601
		//	}

        do {
            returnedDecodable = try decoder.decode(type, from: data)
        } catch {
            returnedError = error
        }

        return (returnedDecodable, returnedError)
    }

    open class func encode<T>(_ value: T, prettyPrint: Bool = false) -> EncodeResult where T : Encodable {
        var returnedData: Data?
        var returnedError: Error? = nil

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
		encoder.dateEncodingStrategy = .formatted(DateFormatter.jsonDate)	 // It is necessary for correct decoding. Timestamp -> Date.
//        encoder.dataEncodingStrategy = .base64
//        if #available(iOS 10.0, *) {
//            encoder.dateEncodingStrategy = .iso8601
//        }

        do {
            returnedData = try encoder.encode(value)
        } catch {
            returnedError = error
        }

        return (returnedData, returnedError)
    }

}
