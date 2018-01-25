//
//  FuncHouse.swift
//  BoostMINI
//
//  Created by HS Lee on 24/01/2018.
//  Copyright © 2018 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit

class FuncHouse {

    class func runOnMainThread(fn: @escaping () -> Void) {
        DispatchQueue.main.async {//run in mainThread
            fn()
        }
    }
    
    class func runOnBackgroundThread(fn: @escaping () -> Void) {
        DispatchQueue.global().async {//run in mainThread
            fn()
        }
    }
    
    /** convenience for dispatch_after  */
    class func dispatchAfter(duration: Double, fn: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            fn()
        }
    }

}

extension FuncHouse {

}
