//
//  UIView+BorderUIExtension.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 10..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit


extension UIView {
	
	@IBInspectable
	var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
			layer.masksToBounds = newValue > 0
		}
	}
	
	@IBInspectable
	var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}
	
	@IBInspectable
	var borderColor: UIColor? {
		get {
			let color = UIColor(cgColor: layer.borderColor!)
			return color
		}
		set {
			layer.borderColor = newValue?.cgColor
		}
	}
	
	@IBInspectable
	var shadowRadius: CGFloat {
		get {
			return layer.shadowRadius
		}
		set {
			layer.shadowColor = UIColor.black.cgColor
			layer.shadowOffset = CGSize(width: 0, height: 2)
			layer.shadowOpacity = 0.4
			layer.shadowRadius = shadowRadius
		}
	}
	
	
	public func draw(_ layer: CALayer, in ctx: CGContext) {
		
		clipsToBounds = true
		layer.cornerRadius = cornerRadius
		layer.borderWidth = borderWidth
		layer.borderColor = borderColor?.cgColor
		
	}
}
