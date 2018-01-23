//
//  UserDefault+CustomClass.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 15..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit

extension UserDefaults {
	
	open func setCodable<T: Codable>(_ value: T?, forKey defaultName: String) {
		guard let val = value else {
			//logError("setCodable value is nil. (\(value))")
			removeObject(forKey: defaultName)
			return
		}
		
		let data = CodableHelper.encode(val)
		guard let encoded = data.data else {
			logError("corrupted data to save. (\(defaultName)) : \(String(describing: data.error))")
			return
		}
		set(encoded, forKey: defaultName)
	}

	open func objectCodable<T: Codable>(forKey defaultName: String) -> T? {
		guard let encoded = object(forKey: defaultName) as? Data else {
			return nil
		}
		
		let dec = CodableHelper.decode(T.self, from: encoded)
		guard let data = dec.decodableObj else {
			logError("corrupted data to load. (\(defaultName)) : \(String(describing: dec.error))")
			return nil
		}
		return data
	}

	
	open func setArchive<T>(_ value: T, forKey defaultName: String) {
		let value = NSKeyedArchiver.archivedData(withRootObject: value)
		set(value, forKey: defaultName)
	}
	
	open func objectArchived<T>(forKey defaultName: String) -> T? {
		guard let decoded = object(forKey: defaultName) as? Data,
			let data = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? T
			else {
				return nil
		}
		return data
	}

}
