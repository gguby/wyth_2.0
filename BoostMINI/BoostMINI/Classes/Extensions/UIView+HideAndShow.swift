//
//  UIView+HideAndShow.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 4..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit

extension UIView {

	func show() {
		if self.isHidden {
			self.alpha = 0
			self.isHidden = false
		}
		
		UIView.animate(withDuration: 0.25,
					   animations: {
						self.alpha = 1
		}) { fin in
			if fin {
				// nothing
			}
		}
	}

	func hide() {
		UIView.animate(withDuration: 0.25,
					   animations: {
						self.alpha = 0
		}) { fin in
			if fin {
				self.isHidden = true
				self.alpha = 1.0
			}
		}
	}
	
}
