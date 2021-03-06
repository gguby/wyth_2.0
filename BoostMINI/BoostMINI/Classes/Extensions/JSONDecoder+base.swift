//
//  JSONDecoder+base.swift
//  SMLightStick
//
//  Created by jack on 2017. 12. 18..
//  Copyright © 2017년 jack. All rights reserved.
//

import Foundation


extension JSONEncoder {
	static var base: JSONEncoder {
		let encoder = JSONEncoder()
		
		encoder.outputFormatting = .prettyPrinted
		//encoder.dataEncodingStrategy = .base64
		encoder.dateEncodingStrategy = .formatted(DateFormatter.jsonDate) // .iso8601
		
		return encoder
	}
}


extension JSONDecoder {
	
	static var base: JSONDecoder {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .formatted(DateFormatter.jsonDate)	 // It is necessary for correct decoding. Timestamp -> Date.
		
		return decoder
	}

	// swift 4.1 -> decoder.keyDecodingStrategy = .convertFromSnakeCase
	
}


