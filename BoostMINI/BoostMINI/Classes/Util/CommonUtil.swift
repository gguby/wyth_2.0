//
//  CommonUtil.swift
//  BoostMINI
//
//  Created by HS Lee on 21/12/2017.
//  Modified by DK Park on 26/12/2017.
//  Copyright © 2017 IRIVER LIMITED. All rights reserved.
//

import UIKit
// import Foundation

let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.size.height

class CommonUtil {

    // MARK: * properties --------------------

    // MARK: * IBOutlets --------------------

    // MARK: * Initialize --------------------

    init() {}

    // MARK: * Main Logic --------------------

}

extension CommonUtil {

    /// 타입명 스트링 반환
    /// 뷰컨트롤러에 대해서만 테스트됨.
    /// 코드프로젝트 등에서 많이 쓰이는 코드.
    ///
    /// - Parameter object: 객체
    /// - Returns: 해당 객체의 이름.
    class func getTypeName(_ object: Any) -> String {
        return (object is Any.Type) ? "\(object)" : "\(type(of: object))"
    }

    /// 최상위 윈도우 반환
    /// (리슨에서 쓰던 코드를, swift4에서 동작되도록 수정)
    /// - Returns: 최상위 윈도우
    class func getTopWindow() -> UIWindow? {//BSTUXHandler, BSTUXManager
        var topWindow: UIWindow?
        for window: UIWindow in UIApplication.shared.windows.reversed() {
            let windowClassName: String = getTypeName(window) // NSStringFromClass(window)
            #if !PRODUCT
                if "FLEXWindow" == windowClassName {
                    continue
                }
            #endif
            if let transitionView = window.subviews.last,
                transitionView.frame.origin.y < SCREEN_HEIGHT,
                windowClassName.contains("UITextEffectsWindow") {

                topWindow = window
                break
            }
        }
        return topWindow
    }

    /// 최상위 뷰컨트롤러 반환.
    ///
    /// - Returns: 최상위 뷰 컨트롤러
    class func getTopViewController() -> UIViewController? {

        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            return topController
        }
        return nil
    }
	
	/// 최상위 뷰컨트롤러 반환.
	///
	/// - Parameter viewController:
	/// - Returns:
	func topVisibleViewController(_ viewController: UIViewController) -> UIViewController? {
		let viewController = viewController ?? UIApplication.shared.keyWindow?.rootViewController
		
		if let navigationController = viewController as? UINavigationController,
			let last = navigationController.viewControllers.last  {
			return topVisibleViewController(last)
		}
		else if let tabBarController = viewController as? UITabBarController,
			let selectedController = tabBarController.selectedViewController {
			return topVisibleViewController(selectedController)
		}
		else if let presentedController = viewController?.presentedViewController {
			return topVisibleViewController(presentedController)
		}
		
		return viewController
	}
}
