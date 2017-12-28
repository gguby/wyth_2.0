//
//  JSONDecoder+base.swift
//  SMLightStick
//
//  Created by jack on 2017. 12. 18..
//  Copyright © 2017년 jack. All rights reserved.
//

import UIKit

extension JSONDecoder {
	
	static var base: JSONDecoder {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .secondsSince1970 // It is necessary for correct decoding. Timestamp -> Date.
		
		
		return decoder
	}

	// swift 4.1 -> decoder.keyDecodingStrategy = .convertFromSnakeCase
	
}

