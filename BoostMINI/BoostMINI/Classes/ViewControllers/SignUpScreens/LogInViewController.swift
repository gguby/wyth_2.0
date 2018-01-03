//
//  LogInViewController.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 26..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import ReactorKit

/// 로그인 하기 전의 화면임.
class LogInViewController: UIViewController {

	@IBOutlet weak var loginButtonView: UIView!
	@IBOutlet weak var tiltingView: TopTiltingView!

	override func viewDidAppear(_ animated: Bool) {
		if tiltingView.isHidden {
			showStartAnimation()
		}
	}
}


extension LogInViewController {
	func showStartAnimation() {
		tiltingView.isHidden = false
		
		let duration: TimeInterval = 1.3
		tiltingView.updateDisplayTiltMaskPercentage(1.0, 1.0)
		self.tiltingView.updateDisplayTiltMaskPercentage(1.0, 0.0, animation: true, duration: duration)

	}
}
