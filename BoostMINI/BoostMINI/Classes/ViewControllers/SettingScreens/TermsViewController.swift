//
//  TermsViewController.swift
//  BoostMINI
//
//  Created by  KoMyeongbu on 2018. 1. 8..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit

class TermsViewController: WebViewController {

    // MARK: - * properties --------------------


    // MARK: - * IBOutlets --------------------

    
    // MARK: - * Initialize --------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWebUrl("http://boostdev.lysn.com:8181/viewTerms?userId=1")
    }

}

