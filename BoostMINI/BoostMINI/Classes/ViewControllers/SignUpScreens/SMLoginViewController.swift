//
//   SMLoginViewController.swift
//  Vyrl2.0
//
//  Created by wsjung on 2017. 5. 22..
//  Copyright © 2017년 smt. All rights reserved.
//

import UIKit

protocol SMLoginDelegate {
    func login(token:String)
}

class SMLoginViewController : WebViewController {
    
    // var clientId = BSTConstants.path.clientId
    var loginDelegate: SMLoginDelegate? = nil
	
    @IBOutlet weak var btnClose: UIButton!
	var isLogin: Bool { return token != nil }
    var token: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.loadWebUrl(BSTConstants.path.authUri)
    }
//
//    @IBAction func dismiss(sender :AnyObject ) {
//        self.navigationController?.popViewController(animated: true)
//    }
	
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if navigationType != UIWebViewNavigationType.formSubmitted {
            return true
        }
        
        var command : String = (request.url?.absoluteString)!.decodeURL()
        
        command = command.replacingOccurrences(of: "#", with: "?")
        
        let url = URL.init(string: command)
        
        if ( url?.query!.hasPrefix("access_token"))!
        {
            let token = url?.queryParameters!["access_token"]
            loginDelegate?.login(token: token!)
        }
        
        return true
    }
    
}


