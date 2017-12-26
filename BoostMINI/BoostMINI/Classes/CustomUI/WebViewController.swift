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
	
	func loadWebUrl(_ urlString: String) {
		
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
			not(isIndicatorInProgress) {
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
		NotificationCenter.default.post(name: NSNotification.Name(notificationType), object: object, userInfo: nil)
	}
	
	func postNotification(_ notificationType: String, params: [AnyHashable: Any]?) {
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
		if not(titleString.isEmpty) {
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
	}
	
	// MARK: - WKWebView UIDelegate
	func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
		print("""
			\(#function)
			\(frame.request.url?.absoluteString ?? "")
			""")
		SystemAlert.show(nil, message: message, cancel: SystemAlert.text.ok, completion: {(_ cancel: Bool) -> Void in
			completionHandler()
		})
	}
	
	// 이 코드를 넣으면 웹뷰가 제대로 동작하지 않는다...
	//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
	//
	//    if ([navigationResponse.response isKindOfClass:[NSHTTPURLResponse class]]) {
	//        NSHTTPURLResponse * response = (NSHTTPURLResponse *)navigationResponse.response;
	//        if (!IS_NULL_OBJECT(response) && (((NSHTTPURLResponse *) response).statusCode < 200 || ((NSHTTPURLResponse *) response).statusCode > 299)) {
	//            NSError *error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:((NSHTTPURLResponse *) response).statusCode userInfo:nil];
	//            [self presentNetworkErrorForWebView:error];
	//        }
	//        decisionHandler(WKNavigationResponsePolicyCancel);
	//    }
	//
	//    decisionHandler(WKNavigationResponsePolicyAllow);
	//}
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		if navigationAction.navigationType == .linkActivated {
			decisionHandler(.cancel)
		}
		else {
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
//		initNavigationBar()
		//navigation 타이틀이 사라짐,
		
		showActivity(inStatusBar: false)
		hideActivityIndicator()
	}
	
	func presentNetworkError(_ error: Error) {
//		SMAPIClient.api.presentNetworkError(error, retryBlock: {[weak self] (_ dismissed: Bool, _ isConnected: Bool) -> Void in
//			self?.loadWebUrl(self?.urlString ?? "")
//			}, needCheckServerMaintenance: true)
	}
	
	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		print("""
			\(#function)
			\(error.localizedDescription)
			""")
		self.presentNetworkError(error)
	}
	
	func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
		print("""
			\(#function)
			\(error.localizedDescription)
			""")
		self.presentNetworkError(error)
	}
	
	func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
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
}
