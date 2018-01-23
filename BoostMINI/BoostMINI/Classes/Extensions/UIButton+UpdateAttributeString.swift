//
//  UIButton+UpdateAttributeString.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 12..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit

extension UIButton {

	var text: String? {
		get {
			return self.title(for: .normal)
		}
		
		set {
			let lst: [UIControlState] = [.normal, .highlighted, .disabled, .selected]
			// @available(iOS 9.0, *//)
			// lst += [.focused, .application, .reserved]

			for ee in lst {
				if newValue == nil {
					self.setTitle(nil, for: ee)
					continue
				}
				
				guard let attrTxt = self.attributedTitle(for: ee),
					let normal = self.title(for: ee) else {
					continue
				}
				var range = NSRange()
				attrTxt.attributes(at: 0, effectiveRange: &range)

				let isAttributed: Bool = normal.length() == range.length
				
				if isAttributed && range.length > 0 {
					let attr = attrTxt.attributes(at: 0, effectiveRange: nil)
					let val = NSAttributedString(string: newValue ?? "", attributes: attr)
					self.setAttributedTitle(val, for: ee)
				}
			}
		}
		
	}
	

}
