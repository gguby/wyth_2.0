////
////  NSLayoutConstraint+multiplierSetter.swift
////  BoostMINI
////
////  Created by jack on 2018. 1. 10..
////  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
////
//
//import UIKit
//
//
//extension NSLayoutConstraint {
//
//
//	/// ex)
//	///   var newConstraint = self.constraintToChange.constraintWithMultiplier(0.75)
//	///   self.view!.removeConstraint(self.constraintToChange)
//	///   self.view!.addConstraint(self.constraintToChange = newConstraint)
//	///   self.view!.layoutIfNeeded()
//	///
//	///
//	/// - Parameter multiplier: CGFloat
//	/// - Returns: new NSLayoutConstraint
//	func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
//		return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
//	}
//
//
//}
//
//extension UIView {
//	func changeConstraint(_ original:NSLayoutConstraint, multiplier: CGFloat) -> NSLayoutConstraint {
//		let newConstraint = original.constraintWithMultiplier(multiplier)
//		self.removeConstraint(original)
//		self.addConstraint(newConstraint)
//		self.layoutIfNeeded()
//
//		return newConstraint
//	}
//
//}

