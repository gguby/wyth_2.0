//
//   SMLoginViewController.swift
//  Vyrl2.0
//
//  Created by wsjung on 2017. 5. 22..
//  Copyright © 2017년 smt. All rights reserved.
//

import UIKit

protocol SMLoginDelegate {
    func login(token: String)
}

class SMLoginViewController: WebViewController {

    // var clientId = Definitions.path.clientId
    var loginDelegate: SMLoginDelegate?

    @IBOutlet var btnClose: UIButton!
    var isLogin: Bool { return token != nil }
    var token: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebUrl(Definitions.path.authUri)
    }
    //
//    @IBAction func dismiss(sender :AnyObject ) {
//        self.navigationController?.popViewController(animated: true)
//    }

    func webView(_: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        if navigationType != UIWebViewNavigationType.formSubmitted {
            return true
        }

        var command: String = (request.url?.absoluteString)!.decodeURL()

        command = command.replacingOccurrences(of: "#", with: "?")

        let url = URL(string: command)

        if (url?.query!.hasPrefix("access_token"))! {
//            let token = url?.queryParameters!["access_token"]
//            loginDelegate?.login(token: token!)
        }

        return true
    }
}
