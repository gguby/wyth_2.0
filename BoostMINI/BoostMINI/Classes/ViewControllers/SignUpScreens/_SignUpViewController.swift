//
//  SignUpViewController.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 26..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import UIKit

class SignUpViewController: WebViewController {

    // MARK: * properties --------------------

    // MARK: * IBOutlets --------------------

    // MARK: * Initialize --------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        setUrl("https://now.smtown.com/Register")
        loadWebUrl(urlString)

        initProperties()
        initUI()
        prepareViewDidLoad()
    }

    private func initProperties() {
    }

    private func initUI() {
    }

    func prepareViewDidLoad() {
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
