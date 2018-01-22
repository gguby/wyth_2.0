//
//  BSTUXHandler-LoadingIndicator.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 19..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit

extension BSTUXHanlder {

	class LoadingIndicator {

		private static let privateInstance = LoadingIndicator()
		private init() { }
		private var window: UIWindow?
		private var duration: TimeInterval = 0.5
		
		class func show(message messageTemp: String? = nil,
						blockUI: Bool = true,
						animate: Bool = true,
						customBackgroundColor: UIColor = UIColor.clear) {
			
			if privateInstance.window == nil {
				privateInstance.window = UIWindow(frame: UIScreen.main.bounds)
			} else {
				if privateInstance.window!.isHidden == false {
					//logVerbose("indicator already shown")
					//hide()
					return
				}
			}
			let window = privateInstance.window!

			let loadingVC = R.storyboard.common.loadingViewController()

			window.frame = UIScreen.main.bounds
			window.rootViewController = loadingVC
			
			loadingVC?.view.backgroundColor = customBackgroundColor
			
			window.windowLevel = UIWindowLevelAlert - 1
			window.makeKeyAndVisible()
			window.isUserInteractionEnabled = blockUI
			loadingVC?.view.isUserInteractionEnabled = blockUI
			
			window.alpha = 0
			window.isHidden = false
			UIView.animate(withDuration: (animate ? privateInstance.duration : 0)) {
				window.alpha = 1.0
			}

			loadingVC?.indicator.startAnimating()

		}
		
		class func hide(animate: Bool = true, message messageTemp: String? = nil) {
			guard let window = privateInstance.window else {
				return
			}
			window.isUserInteractionEnabled = false

			UIView.animate(withDuration: (animate ? privateInstance.duration : 0), animations: {
				window.alpha = 0
			}) { fin in
				window.isHidden = true
			}
		}
	}
}
