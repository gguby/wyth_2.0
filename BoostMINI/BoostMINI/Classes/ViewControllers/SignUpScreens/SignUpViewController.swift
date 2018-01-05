//
//  SignUpViewController.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 26..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import ReactorKit
import RxCocoa
import RxSwift

class SignUpViewController: WebViewController {

    // MARK: * properties --------------------

    // MARK: * IBOutlets --------------------

    // MARK: * Initialize --------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadWebUrl(urlString)

        initProperties()
        initUI()
        prepareViewDidLoad()
    }

    private func initProperties() {
    }

	var disposeBag = DisposeBag()
    private func initUI() {
		if let lbl = view.viewWithTag(9001) as? UILabel {
			lbl.text = BSTFacade.localizable.login.smLoginText()
			lbl.text = "e"
		}
		
		
//		goHome.rx.tap.subscribe() { event in
//			self.presentHome()
//			}.disposed(by: disposeBag)
//		goLogin.rx.tap.subscribe() { event in
//			self.presentLogin()
//			}.disposed(by: disposeBag)
//

    }

    func prepareViewDidLoad() {
        
        
//        LoginModel.post { () in
//
//        }
        
    }

    // MARK: * Main Logic --------------------

    // MARK: * UI Events --------------------

    // MARK: * Memory Manage --------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SignUpViewController {
}
