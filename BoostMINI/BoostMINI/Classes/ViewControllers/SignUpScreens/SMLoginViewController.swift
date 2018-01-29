//
//  SignUpViewController.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 26..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//
import UIKit
import WebKit


class SMLoginViewController: WebViewController {

	// var clientId = Definitions.path.clientId

	
	
	var token: String? { return SessionHandler.shared.token }
	var preload: String?

	
    override func viewDidLoad() {
        super.viewDidLoad()
        
		initNotifications()
		initData()
		loadWebUrl(Definitions.externURLs.authUri, preload: preload, forceRefresh: false)
		preload = nil

	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	
	
	override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		super.webView(webView, didFinish: navigation)

		if let savedEmail = SessionHandler.shared.savedEmail {
			let val = savedEmail
			let script = """
			$('#UserID').val('\(val)');
			$('#isPersistent')[0].checked = true;
			$('#isPersistent')[0].click( function(){
				try {
					var email = $('#isPersistent')[0].checked ? $('#UserID').val() : ''
					webkit.messageHandlers.smboost.postMessage('save_email:'+ email) );
				} catch(err) {
					console.log('The native context does not exist yet');
				}
			});
			"""
			webView.evaluateJavaScript(script)
		}
	}
	
	override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		// TODO: NOT WORKING
		if message.name.starts(with: "save_email:") {
			let splitted: String = message.name.components(separatedBy: ":").last ?? ""
			if splitted.length() > 0 {
				SessionHandler.shared.savedEmail = splitted
			} else {
				SessionHandler.shared.savedEmail = nil
			}
		}
		super.userContentController(userContentController, didReceive: message)
	}
	

	@objc func receivedWelcome(notification: Notification) {
		// openWelcome()
		
		guard let vc = R.storyboard.signUp.agreementController() else {
			BSTError.debugUI(.storyboard("SignUp.agreementController"))
				.cookError()
			return
		}
		// 얘는 push
		self.navigationController?.pushViewController(vc, animated: true)

	}
	
	@objc func receivedLogin(notification: Notification) {
		BSTFacade.go.home()

	}
	
	@objc func receivedLoginFailed(notification: Notification) {
		if let error = notification.object as? BSTError {
			error.cook(nil)
			return
		}
		if let error = notification.object as? Error {
			BSTFacade.ux.showAlert(error.localizedDescription)
			return
		}
	}
}

extension SMLoginViewController {

	func initNotifications() {
		for (key, value) in [
			BoostNotificationLogin.needRegister.name : #selector(self.receivedWelcome(notification:)),
			BoostNotificationLogin.login.name : #selector(self.receivedLogin(notification:)),
			BoostNotificationLogin.failed.name : #selector(self.receivedLoginFailed(notification:))
			] {
				NotificationCenter.default.addObserver(self,
													   selector: value,
													   name:key,
													   object: nil)
		}
	}
	
	
	func initData() {
        BSTFacade.session.resetCookies()
	}
}
