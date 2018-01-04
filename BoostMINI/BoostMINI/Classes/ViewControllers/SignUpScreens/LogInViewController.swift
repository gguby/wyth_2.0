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
import RxOptional
import ReactorKit
import TransitionButton

/// 로그인 하기 전의 화면임.
class LogInViewController: UIViewController {

	@IBOutlet weak var loginButton: TransitionButton!
	@IBOutlet weak var loginButtonView: UIView!
	@IBOutlet weak var tiltingView: TopTiltingView!

	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		initEvents()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		if tiltingView.isHidden {
			showStartAnimation()
		}
	}
	
	
	let disposeBag = DisposeBag()
	func initEvents() {
		loginButton.rx.controlEvent([.touchDown]).bind {
			loginButton.backgroundColor =
			}
//			.flatMapLatest { _ in // () -> ObservableConvertibleType in
//				Observable<Int64>.interval(0.1, scheduler: MainScheduler.instance)
//					.takeUntil(self.loginButton.rx_controlEvent([.TouchUpInside, .touchUpOutside]))
//			}
//			.subscribeNext{ _ in
//
//			}
			.addDisposableTo(disposeBag)
		
		loginButton.rx.tap.bind {
			self.openSmLogin()
			}.disposed(by: disposeBag)
	}
}


extension LogInViewController {
	
	func showStartAnimation() {
		// 하단 하이라이트 삐딱하게 튀어나오도록 애니메이션
		tiltingView.isHidden = false
		
		let duration: TimeInterval = 1.3
		tiltingView.updateDisplayTiltMaskPercentage(1.0, 1.0)
		self.tiltingView.updateDisplayTiltMaskPercentage(1.0, 0.0, animation: true, duration: duration)
	}

	func openSmLogin() {
		
		logVerbose("sm login")
		
		guard let button = self.loginButton else {
			BSTFacade.ux.showToast(["login failed.".locale, "(error : -2)"].joined())
			return
		}
		
		loginButtonView.hide()
		button.startAnimation()
		let qualityOfServiceClass = DispatchQoS.QoSClass.background
		let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
		backgroundQueue.async(execute: {
			

			var html: String = ""
			//var isFailed = false
			// web preload
			do {
				let path = Definitions.externURLs.authUri
				html = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
			} catch {
				BSTFacade.ux.showToast(["login failed.".locale, "(error : -1)"].joined())
				RunInNextMainThread {
					button.stopAnimation(animationStyle: .expand, completion: {
						self.loginButtonView.show()
					})
				}
				
				return
			}
			
			DispatchQueue.main.async(execute: { () -> Void in
				
				button.stopAnimation(animationStyle: .expand, completion: {
					let newVC = SMLoginViewController.create("SignUp")
					if not(html.isEmpty) {
						newVC.preload = html
					}
					self.navigationController?.pushViewController(newVC, animated: true)
				})
			})
		})
	}
	
}
