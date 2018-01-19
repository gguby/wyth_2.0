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
		// 네트워크가 느릴 경우, 매 요청마다 1.5초씩 인터렉션이 안되는듯한 느낌이 들게 되기떄문에, 그냥 누르면 바로라도 닫히도록 처리하자.
//		if Date().timeIntervalSince(dateCreated) < 1.5 { return } // 뷰가 생성된지 1.5초도 안된 상황에서의 터치 이벤트는 무시
		
		BSTFacade.ux.hideIndicator()
	}
}
