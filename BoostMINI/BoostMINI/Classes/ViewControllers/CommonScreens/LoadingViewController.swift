//
//  LoadingViewController.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 19..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

	@IBOutlet weak var viewIndicator: UIView!
	@IBOutlet weak var indicator: UIActivityIndicatorView!

	let dateCreated = Date()
	
	
	@IBAction func backgroundTouchDown(_ sender: Any) {
		if Date().timeIntervalSince(dateCreated) < 1.5 {
			// 뷰가 생성된지 1.5초도 안된 상황에서의 터치 이벤트는 무시
			return
		}
		
		BSTFacade.ux.hideIndicator()
	}
}
