//
//  LoadingViewController.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 19..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit

class LoadingViewController: BoostUIViewController {

	@IBOutlet weak var viewIndicator: UIView!
	@IBOutlet weak var indicator: UIActivityIndicatorView!

	let dateCreated = Date()
	
	@IBAction func backgroundTouchDown(_ sender: Any) {
		BSTFacade.ux.hideIndicator()
	}
}
