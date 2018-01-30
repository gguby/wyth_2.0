//
//  UIView+Addition.swift
//  BoostMINI
//
//  Created by HS Lee on 30/01/2018.
//  Copyright © 2018 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    //해당하는 constraint를 찾아 반환함.
    func getConstraint(attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        //first, find on super
        var constraint = superview?.constraints.filter({ $0.firstItem === self && $0.firstAttribute == attribute }).first
        constraint = constraint == nil ? superview?.constraints.filter({ $0.secondItem === self && $0.secondAttribute == attribute }).first : constraint
        
        //second, find on self
        constraint = constraint == nil ? self.constraints.reversed().filter({ $0.firstItem === self && $0.firstAttribute == attribute }).first : constraint
        return constraint
    }
}

