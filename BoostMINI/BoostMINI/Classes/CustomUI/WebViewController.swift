//
//  WebViewController.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 26..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, UIScrollViewDelegate, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, UIGestureRecognizerDelegate {
	@IBOutlet weak var webViewContainer: UIScrollView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView?
	@IBOutlet weak var titleLabel: UILabel?
	@IBOutlet weak var cancelButton: UIButton?
	@IBOutlet weak var topBar: UIView?
	

	var configuration: WKWebViewConfiguration!
	var webView: WKWebView!
	
	lazy var localizedDateFormatter = DateFormatter()
	
	var isIndicatorInProgress = false
	var titleString = ""
	var urlString = ""
	
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func initWebView() {
		if configuration != nil && webView != nil {
			return
		}
		configuration = WKWebViewConfiguration()
		configuration.userContentController.add(self, name: "smboost")
		
		webView = WKWebView(frame: webViewContainer.bounds, configuration: configuration)
		webView.uiDelegate = self
		webView.navigationDelegate = self
		webView.isOpaque = false
		webView.configuration.preferences.javaScriptEnabled = true
		webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		automaticallyAdjustsScrollViewInsets = supportLayoutUnderNavigationBar()
		webView.scrollView.delegate = self
		webViewContainer.addSubview(webView)
	}
	
	func setTitle(_ text:String, url:String) {
		titleString = text // title ?? ""
		self.urlString = url
	}
	
	func setUrl(_ urlString: String) {
		self.urlString = urlString
	}

	func loadWebHtml(_ html: String, _ url: URL?) {
		self.webView.loadHTMLString(html, baseURL: url)
		
		// 인디게이터가 처음에 강제로 돌므로, 이를 꺼준다.
		self.hideActivityIndicator()
		self.showActivity(inStatusBar: false)
	}
	
	func loadWebUrl(_ urlString: String,
					preload: String? = nil,
					forceRefresh:Bool = false) {

		
		if let html = preload {
		self.webView.loadHTMLString(html, baseURL: urlString.asUrl)
			if !forceRefresh {
				// 인디게이터가 처음에 강제로 돌므로, 이를 꺼준다.
				self.showActivity(inStatusBar: false)
				self.hideActivityIndicator()
				return
			}
		}
		
		self.urlString = urlString
		if urlString.length() == 0 {
			self.webView.loadHTMLString("", baseURL: nil)
			return
		}
		
		
		DispatchQueue.global(qos: .default).async(execute: {
			DispatchQueue.main.async(execute: { [weak self] () -> Void in
				if let ss = self, let wv = ss.webView {
					let request = NSMutableURLRequest(url: URL(string: urlString)!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
					wv.load(request as URLRequest)
					ss.showActivity(inStatusBar: true)
					ss.showActivityIndicator()
				}
			})
		})
	}
	
	
	
	
	@IBAction func back(_ sender: Any) {
		if navigationController?.popViewController(animated: true) == nil {
			self.dismiss(animated: true)
		}
	}
	
	func showActivity(inStatusBar isShown: Bool) {
		if UIApplication.shared.isNetworkActivityIndicatorVisible {
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
		UIApplication.shared.isNetworkActivityIndicatorVisible = isShown
	}
	
	func showActivityIndicator() {
		if let indicator = activityIndicator,
			!(isIndicatorInProgress) {
			isIndicatorInProgress = true
			indicator.isHidden = false
			indicator.startAnimating()
		}
		
	}
	
	func hideActivityIndicator() {
		if let indicator = activityIndicator,
			isIndicatorInProgress {
			isIndicatorInProgress = false
			indicator.stopAnimating()
			indicator.isHidden = true
		}
	}
	
	func dismissNavigationController() {
		let transition = CATransition()
		transition.duration = 0.3
		transition.type = kCATransitionReveal
		transition.subtype = kCATransitionFromLeft
		view.window?.layer.add(transition, forKey: nil)
		navigationController?.dismiss(animated: false)
	}

	func supportLayoutUnderNavigationBar() -> Bool {
		return true
	}
	
	
	func getDummyImage(_ color: UIColor) -> UIImage {
		let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
		color.setFill()
		UIRectFill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image ?? UIImage()
	}
	
	func refreshScreen() {
}
	
	// MARK: - Post Notification
	func postNotification(_ notificationType: String, object: Any?) {
		logVerbose("webView - %@(%@, \(object))".format(#function, notificationType))
		NotificationCenter.default.post(name: NSNotification.Name(notificationType), object: object, userInfo: nil)
	}
	
	func postNotification(_ notificationType: String, params: [AnyHashable: Any]?) {
		logVerbose("webView - %@(%@,\(params))".format(#function, notificationType))
		NotificationCenter.default.post(name: NSNotification.Name(notificationType), object: nil, userInfo: params)
	}
	
	
	
	func supportAutomaticStatusBarStyle() -> Bool {
		return true
	}
	
	override var prefersStatusBarHidden: Bool {
		return false
	}
	
	// MARK: - Orientation
	override var shouldAutorotate: Bool {
		return false
	}
	
	//    func shouldAutorotate(to interfaceOrientation: UIInterfaceOrientation) -> Bool {
	//        return true
	//    }
	
	override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
		return .portrait
	}

	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}

	
	// MARK: - View Life Cycle
	override func loadView() {
		super.loadView()
		initWebView()
		navigationController?.interactivePopGestureRecognizer?.delegate = self
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		initWebView()

		if urlString.isEmpty {
			urlString = defaultUrlString() ?? ""
			if urlString.isEmpty {
				return
			}
		}
		loadWebUrl(urlString)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		refreshScreen()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		//trackWebScreen()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	
	
	// MARK: - Analytics call
	func trackWebScreen() {
//		var screenName: String? = nil
		//로그인,
		//    UserData *userData = [UserData sharedInstance];
		if !(titleString.isEmpty) {
//			if (titleString == localizedText.login.service_term_title) {
//				screenName = "LoginJoin_ServiceTerms"
//			}
//			else if (titleString == localizedText.login.privacy_title) {
//				screenName = "LoginJoin_PrivacyPolicy"
//			}
		}
		
		//send screen log to Analytics Services.
//		if let screenName = screenName, !screenName.isEmpty {
//			SMUtil.trackScreen(screenName)
//		}
	}

	
	
	// MARK: - Web View (Overriding)
	
	func defaultUrlString() -> String? {
		return nil
	}
	
	// MARK: - Navigation Bar (Overriding)
	
	func navigationBarTitleColor() -> UIColor? {
		return nil
	}
	
	// MARK: - WKScriptMessageHandler
	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		logVerbose("webView - %@(%@)".format(#function, message))
	}
	
	// MARK: - WKWebView UIDelegate
	func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
		print("""
			\(#function)
			\(frame.request.url?.absoluteString ?? "")
			""")
		
		BSTFacade.ux.showAlert(message) {
			completionHandler()
		}
	}
	
	
	@IBAction func cancelButtonTouched(_ sender: Any) {
		if let nav = self.navigationController {
			nav.popViewController(animated: true)
			return
		}
		self.dismiss(animated: true)
	}
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		logVerbose("webView - %@(%d)".format(#function, navigationAction.navigationType.rawValue))
		
		if webView != self.webView {
			decisionHandler(.allow)
			return
		}
		
		if let url = navigationAction.request.url {
			if navigationAction.targetFrame == nil {
				let url = navigationAction.request.url
				if url?.description.range(of: "http://") != nil || url?.description.range(of: "https://") != nil || url?.description.range(of: "mailto:") != nil || url?.description.range(of: "tel:") != nil  {
					UIApplication.shared.openURL(url!)
				}
			}
			if navigationAction.targetFrame == nil {
				let app = UIApplication.shared
				if app.canOpenURL(url) {
					//app.openURL(url)
					app.open(url, options: [:], completionHandler: { b in
					})
					decisionHandler(.cancel)
					return
				}
			}
		}
		
		if navigationAction.navigationType == .formSubmitted
			|| navigationAction.navigationType == .other {
			
			//  other "http://api.dev2nd.vyrl.com/#/authSignIn"
			// formSubmitted 일 경우에 가져옴
			
			
			// queryParameters 부분구현부가 조금 달라보인다.
			// 처리해야할 주소 : http://api.dev2nd.vyrl.com/#/access_token=GukNHQQufLmTWSmtdhes2x1...
			// 기존 코드가 변환하는 주소 : /access_token=GukNHQQufLmTWSmtdhes2x1...
			// 실제로 변환해야 하는 주소 : access_token=GukNHQQufLmTWSmtdhes2x1...
			// queryParameters에서 추출하는 구조 : { "access_token":"GukNHQQufLm...", "token_type":"bearer", "expires_in":3600, "state":"nonce" ... }
			
			// .query가 아닌 URLComponents.queryItems 을 사용중이나, 원하는대로 변환되지 않는듯.
			// [URL]/#/[PARAM] 형식을 인지하게 기능 확장.
			
			
			
			if let command = navigationAction.request.url?.absoluteString.decodeURL()
				.replacingOccurrences(of: "#", with: "?")
				.replacingOccurrences(of: "/?/", with: "/?") {

				let params = command.queryParameters
				
				if let token = params["access_token"] { //, not(token.isEmpty) {
					
					// 로그인이라면 그 이후의 페이지들을 보여줄이유는없다. 뷰 자체를 종료하도록한다.
					if token.isEmpty {
						// BoostProfile.logout()
						logVerbose("access_token lost.")
						
					} else {
						// TODO : 기존코드의 문제. 일단 로그인되어있으면, 토큰이 붙는데... 로그인 화면을 보여주고싶을 뿐인거다 난. 구분을 하든가 로그아웃을 하든가.
						// TODO : 만약 로그인을 한 후, 약관동의화면에서 앱을 종료하면... 다음번 앱 실행 후 로그인을 눌렀을 때 이리로 온다. 이미 smtown은 로그인이 되어있어서 그렇다. 이 경우, 약관동의화면으로 가지 않게 하려면 smtown 로그인을 해제할 수 있어야 한다.
						
						logVerbose("access_token got.")
						BoostProfile.login(token)
					}
					decisionHandler(.cancel)
					return
				}
			}
		}
			
		logVerbose("MORE : \(webView.url?.absoluteString ?? "")")
		if navigationAction.navigationType == .linkActivated {
			//decisionHandler(.cancel)
			decisionHandler(.allow)
		} else {
			decisionHandler(.allow)
		}

	}
	
	func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
		print("""
			\(#function)
			\(frame.request.url?.absoluteString ?? "")
			""")
	}
	
	func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
	}
	
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		logVerbose("webView - %@".format(#function))
//		initNavigationBar()
		//navigation 타이틀이 사라짐,
		
		titleLabel?.text = webView.title
		
		
		
		showActivity(inStatusBar: false)
		hideActivityIndicator()
	}
	
	
	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		logVerbose("webView - %@".format(#function))
		titleLabel?.text = ""
		print("""
			\(#function)
			\(error.localizedDescription)
			""")
		self.presentNetworkError(error)
	}
	
	func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
		logVerbose("webView - %@".format(#function))
		titleLabel?.text = ""
		print("""
			\(#function)
			\(error.localizedDescription)
			""")
		self.presentNetworkError(error)
	}
	
	func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		logVerbose("webView - %@".format(#function))
		completionHandler(.useCredential, nil)
	}
	
	/*
	#pragma mark - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	}
	*/
//	func scrollViewDidScroll(_ scrollView: UIScrollView) {
//		if scrollView == webView?.scrollView {
//			view.bringSubview(toFront: viewNavigationLine ?? UIView())
//			viewNavigationLine?.setHidden((scrollView.contentOffset.y < 2.0), animation: true)
//		}
//	}
	
	
	func presentNetworkError(_ error: Error) {
		logVerbose("webView - %@".format(#function))
		//		SMAPIClient.api.presentNetworkError(error, retryBlock: {[weak self] (_ dismissed: Bool, _ isConnected: Bool) -> Void in
		//			self?.loadWebUrl(self?.urlString ?? "")
		//			}, needCheckServerMaintenance: true)
	}

	
	class func show(_ url: String) {
		guard let vc = R.storyboard.common.webViewController() else {
			BSTError.debugUI(.storyboard("common.webViewController"))
				.cookError()
			return
		}
		vc.loadWebUrl(url)
		guard let current = BSTFacade.common.getTopViewController() else{
			BSTError.debugUI(.storyboard("current TopVC"))
				.cookError()
			return
		}
		current.present(vc, animated: true)
	}
		
		
}
