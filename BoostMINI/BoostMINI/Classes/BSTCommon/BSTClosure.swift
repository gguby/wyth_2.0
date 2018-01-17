//
//  BSTClosure.swift
//  BoostMINI
//
//  Created by HS Lee on 17/01/2018.
//  Copyright © 2018 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit

/// 공용 액션(클로져)
class BSTClosure {

    // MARK: - * type alias --------------------

    public typealias emptyAction = () -> Void
    
    public typealias boolAction = (Bool) -> Void
    public typealias intAction  = (Int) -> Void
    public typealias anyAction  = (Any) -> Void
    
    public typealias boolOptionalAction = (Bool?) -> Void
    public typealias intOptionalAction  = (Int?) -> Void
    public typealias anyOptionalAction  = (Any?) -> Void
}
