//
//  Dictionary+Easy.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 22..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import Foundation

extension Dictionary where Key: Any, Value: Any {

    /// object가 nil이면 제거하고, 있으면 추가
    ///
    /// - Parameters:
    ///   - value: 값(object)
    ///   - key: 키
    mutating func setObjectOrRemove(_ value: Value?, forKey key: Key) {
        if value == nil {
            removeValue(forKey: key)
        } else {
            self[key] = value
        }
    }

    /// key가 있을 때에만 업데이트.
    /// key가 있는데 object가 nil이면 제거되고, 있으면 업데이트됨.
    ///
    /// - Parameters:
    ///   - value: 값(object)
    ///   - key: 키
    mutating func setObjectOrIgnore(_ value: Value?, forKey key: Key) {
        if keys.contains(key) {
            setObjectOrRemove(value, forKey: key)
        }
    }
}
