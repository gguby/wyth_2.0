//
//  SignUpViewController.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 26..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import UIKit



//protocol SMLoginDelegate {
//	func login(token: String)
//}

class SMLoginViewController: WebViewController {

	// var clientId = Definitions.path.clientId

    var isLogin: Bool { return token != nil }
    var token: String?
	var preload: String?

    override func viewDidLoad() {
        super.viewDidLoad()
		
		
		if let html = preload {
			self.webView.loadHTMLString(html, baseURL: Definitions.externURLs.authUri.asUrl)
		} else {
        	loadWebUrl(Definitions.externURLs.authUri)
		}
    }
	
	
    func webView(_: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        if navigationType != UIWebViewNavigationType.formSubmitted {
            return true
        }
        guard let command = request.url?.absoluteString.decodeURL().replacingOccurrences(of: "#", with: "?"),
			let url = URL(string: command),
			let query = url.query else {
				return true
		}
		
		let params = query.queryParameters
		if params.keys.contains("access_token") {
			// check more
			let token = params["access_token"] ?? ""
			if not(token.isEmpty) {
				self.login(params["access_token"])
			}
		}
        return true
   }
	
	func login(_ tokenString: String?) {
		guard let token = tokenString else {
			logInfo("login. token : nil")
			// logout?
			return
		}
		
		logVerbose("login.  token :\(token)")
		
	}

}