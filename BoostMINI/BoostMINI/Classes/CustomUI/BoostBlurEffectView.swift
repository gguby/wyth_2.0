//
//  BoostBlurEffectView.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 31..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit
import VisualEffectView

class BoostBlurEffectView: UIView {

	private var effectView: VisualEffectView?
	
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
		if effectView == nil {
			let visualEffectView = VisualEffectView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
			
			// Configure the view with tint color, blur radius, etc
			visualEffectView.colorTint = .clear // BSTFacade.theme.color.commonBgDefault()
			visualEffectView.colorTintAlpha = 0.2
			visualEffectView.blurRadius = 3
			visualEffectView.scale = 1
			self.effectView = visualEffectView
			self.addSubview(visualEffectView)
		}
		
		super.draw(rect)
    }

}
