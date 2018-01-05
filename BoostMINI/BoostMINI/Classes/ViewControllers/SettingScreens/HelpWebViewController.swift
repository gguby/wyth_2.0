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

        if let html = preload {
            self.webView.loadHTMLString(html, baseURL: Definitions.externURLs.appstore.asUrl)
        } else {
            loadWebUrl(Definitions.externURLs.appstore)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
