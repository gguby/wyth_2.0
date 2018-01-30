//
//  AppDelegate.swift
//  BoostMINI
//
//  Created by HS Lee on 12/12/2017.
//  Copyright © 2017 IRIVER LIMITED. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.initializeApp(launchOptions)
        self.initializeThridParties()
        
        //		Logger.destination = [.console, .file]
		Logger.setMinLogLevel(.verbose)

		
		CodableHelper.dateformatter = DateFormatter.jsonDate
		
        return true
    }
    
    ///앱 관련 초기화 설정
    private func initializeApp(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()
    }
    
    ///앱 관련 써드파티, 오픈소스 초기화 설정
    private func initializeThridParties() {
        
    }

    func applicationWillResignActive(_: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else {
                return
            }
            
            // 1
            let noticeAction = UNNotificationAction(identifier: "Notice", title: "Notice", options: [UNNotificationActionOptions.authenticationRequired, UNNotificationActionOptions.foreground])
            
            let noticeCategory = UNNotificationCategory(identifier: "NoticeCategory",
                                                        actions: [noticeAction], intentIdentifiers: [], options: [])
            
            
//            let viewAction = UNNotificationAction(identifier: viewActionIdentifier,
//                                                  title: "View",
//                                                  options: [.foreground])
            
            // 2
//            let newsCategory = UNNotificationCategory(identifier: newsCategoryIdentifier,
//                                                      actions: [viewAction],
//                                                      intentIdentifiers: [],
//                                                      options: [])
            // 3
            UNUserNotificationCenter.current().setNotificationCategories([noticeCategory])
            
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
			DispatchQueue.main.async {
				print("Notification settings: \(settings)")
				
				guard settings.authorizationStatus == .authorized else { return }
				UIApplication.shared.registerForRemoteNotifications()	// main thread only
			}
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let pushToken = tokenParts.joined()
        BSTFacade.session.pushToken = pushToken
        print("PushToken: \(pushToken)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        if BSTDeviceType.isSimulator {
            BSTFacade.session.pushToken = "773d7ed1992b20f035b5ca36b61225267737ba85620646db7491c76b4e530bc4"
        } else {
            print("Failed to register: \(error)")
            BSTFacade.session.pushToken = "TOKEN_ERROR"
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 1
        let userInfo = response.notification.request.content.userInfo
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            logDebug("No payload!!")
            completionHandler()
            return
        }
        
        // 2
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            if let linkURL = aps["link_url"] as? String, let deepLink = URL(string: linkURL) {
                BSTFacade.session.deepLink = deepLink
                if BSTFacade.session.isLoginned {//로그인이 아직 안된 경우에는 추후, 로그인 하고 나서 이동해야함.
                    BSTFacade.ux.goNotification()
                }
            }
        }
//        if let newsItem = NewsItem.makeNewsItem(aps) {
//            (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
//
//            // 3
//            if response.actionIdentifier == viewActionIdentifier,
//                let url = URL(string: newsItem.link) {
//                let safari = SFSafariViewController(url: url)
//                window?.rootViewController?.present(safari, animated: true, completion: nil)
//            }
//        }
        
        // 4
        completionHandler()
    }
}

