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

    var isLogin: Bool { return token != nil }
	var token: String? { return SessionHandler.shared.token }
	var preload: String?

    override func viewDidLoad() {
        super.viewDidLoad()
		
		loadWebUrl(Definitions.externURLs.authUri, preload: preload, forceRefresh: false)
		preload = nil
    }
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.isNavigationBarHidden = false
		super.viewWillAppear(animated)
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	
	// WKWebView
	override func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
	
		
		if navigationAction.navigationType != .formSubmitted &&
			navigationAction.navigationType != .other {
			
			logVerbose("webView - [SM]%@(%d)".format(#function, navigationAction.navigationType.rawValue))
			super.webView(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
			return
		}
		
		
		//  other "http://api.dev2nd.vyrl.com/#/authSignIn"
		// formSubmitted 일 경우에 가져옴
	

		// queryParameters 부분구현부가 조금 달라보인다.
		// 처리해야할 주소 : http://api.dev2nd.vyrl.com/#/access_token=GukNHQQufLmTWSmtdhes2x1...
		// 기존 코드가 변환하는 주소 : /access_token=GukNHQQufLmTWSmtdhes2x1...
		// 실제로 변환해야 하는 주소 : access_token=GukNHQQufLmTWSmtdhes2x1...
		// queryParameters에서 추출하는 구조 : { "access_token":"GukNHQQufLm...", "token_type":"bearer", "expires_in":3600, "state":"nonce" ... }
		
		// .query가 아닌 URLComponents.queryItems 을 사용중이나, 원하는대로 변환되지 않는듯.
		// [URL]/#/[PARAM] 형식을 인지하게 기능 확장.
		
		
		
		
		
		
		guard let command = navigationAction.request.url?.absoluteString.decodeURL()
			.replacingOccurrences(of: "#", with: "?")
			.replacingOccurrences(of: "/?/", with: "/?") else {
				super.webView(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
				return
		}
		let params = command.queryParameters
		
		if let token = params["access_token"] { //, not(token.isEmpty) {
			
			// 로그인이라면 그 이후의 페이지들을 보여줄이유는없다. 뷰 자체를 종료하도록한다.
			if token.isEmpty {
				self.login(nil)
				logVerbose("access_token lost.")
			} else {
				self.login(token)
				logVerbose("access_token got.")
			}
			
			decisionHandler(.cancel)
			return
		}
		// TODO: how to logout?
		decisionHandler(.allow)
		return
	}
		
		
	
//	// UIWebView
//    func webView(_: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//
//        if navigationType != UIWebViewNavigationType.formSubmitted {
//            return true
//        }
//        guard let command = request.url?.absoluteString.decodeURL().replacingOccurrences(of: "#", with: "?"),
//			let url = URL(string: command),
//			let query = url.query else {
//				return true
//		}
//
//		let params = query.queryParameters
//		if let token = params["access_token"], not(token.isEmpty) {
//			self.login(token)
//			return false
//		}
//        return true
//   }
	
	func login(_ tokenString: String?) {
		guard let token = tokenString else {
			logInfo("login. token : nil")
			
			// logout?
			SessionHandler.shared.token = nil
			goIntro()
			return
		}

		// login
		logVerbose("login.  token :\(token)")
		SessionHandler.shared.token = token
		
		goNext()
	}

	func goNext() {
		// 로그인, 회원가입.. 등의 상태에 따라서 홈으로 바로 보내줄 지, 아니면 약관동의 페이지로 보내줄 지의 여부를 판단해야함.
		
		
		guard let token = SessionHandler.shared.token else {
			return
		}
		
		DefaultAPI.signinUsingPOST(accessToken: token, socialType: .smtown) { [weak self] data, err in
			self?.responseSignIn(data, err)
		}
	}
	
	func responseSignIn(_ data: AccountsPostResponse?, _ error: Error?) {
		if let code = BSTErrorTester.checkWhiteCode(error) {
			//	201 : Created			-> 방금 회원가입한 것??
			//	401 : Unauthorized		-> smtown 회원이지만, boost에 가입되지 않은 것?
			//	403 : Forbidden			-> 탈퇴한것???
			//	404 : Not Found			-> 뭔가 잘못되어 회원가입이 되지 않은 것??
			
			switch(code) {
			case 201:
				openWelcome()
			default:
				openWelcome()
			}
			return
		}
		
		if BSTErrorTester.isFailure(error) {
			//logVerbose("error")
			return
		}
		
		guard let token = SessionHandler.shared.token,
			let info = data else {
			logVerbose("nil data")
			return
		}
		
		let profile = BoostProfile.from(info)
		SessionHandler.shared.setSession(token, profile)
		goHome()
	}
	
	func back() {
		// 웹뷰 이전의 인트로인것같은 페이지로 이동
		self.navigationController?.popViewController(animated: true)
	}
	
	
	func goIntro() {	// back()과 동일하다 현재는
		// 인트로인것같은 페이지로 이동 (인트로 끝나고 로그인 버튼 있는 페이지 = 네비게이션 최초 페이지)
		self.navigationController?.popViewController(animated: true)
		
	}
	
	func goHome() {
		BSTFacade.go.home()
	}
	
	func openWelcome() {
		guard let vc = R.storyboard.signUp.agreementController() else {
			BSTError.debugUI(.storyboard("SignUp.agreementController"))
				.cookError()
			return
		}
		// 얘는 push
		self.navigationController?.pushViewController(vc, animated: true)
	}
}
