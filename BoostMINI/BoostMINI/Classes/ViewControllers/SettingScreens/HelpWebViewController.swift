//
//  HelpWebViewController.swift
//  BoostMINI
//
//  Created by  KoMyeongbu on 2018. 1. 5..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit

class HelpWebViewController: WebViewController {
    
    var preload: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadWebUrl("http://boostdev.lysn.com:8181/viewHelpList?userId=1")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
