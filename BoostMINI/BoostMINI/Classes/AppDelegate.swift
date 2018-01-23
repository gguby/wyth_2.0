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
        
        // Check if launched from notification
        // 1
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            // 2
            let aps = notification["aps"] as! [String: AnyObject]
            //TODO: 1.define action 2.move notifications
//            _ = NewsItem.makeNewsItem(aps)
            // 3
//            (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
        }
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
//            let viewAction = UNNotificationAction(identifier: viewActionIdentifier,
//                                                  title: "View",
//                                                  options: [.foreground])
            
            // 2
//            let newsCategory = UNNotificationCategory(identifier: newsCategoryIdentifier,
//                                                      actions: [viewAction],
//                                                      intentIdentifiers: [],
//                                                      options: [])
            // 3
//            UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
            
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
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        if BSTDeviceType.isSimulator {
            BSTFacade.session.pushToken = "773d7ed1992b20f035b5ca36b61225267737ba85620646db7491c76b4e530bc4"
        } else {
            print("Failed to register: \(error)")
            BSTFacade.session.pushToken = "TOKEN_ERROR"
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let aps = userInfo["aps"] as! [String: AnyObject]
        if aps["content-available"] as? Int == 1 {
//            let podcastStore = PodcastStore.sharedStore
//            podcastStore.refreshItems { didLoadNewItems in
//                completionHandler(didLoadNewItems ? .newData : .noData)
//            }
        } else  {
//            _ = NewsItem.makeNewsItem(aps)
//            completionHandler(.newData)
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    /** handle push nontification */
    func handlePushNotification(pushInfo: [NSObject: AnyObject]) {
        logDebug("UIApplication.sharedApplication().applicationState = \(UIApplication.shared.applicationState)")
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        
        if UIApplication.shared.applicationState == UIApplicationState.active {//포어그라운드 일 경우, 보여줌
            //BSTFacade.session.push
            //JDFacade.facade.pushInfo = pushInfo
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 1
        let userInfo = response.notification.request.content.userInfo
        let aps = userInfo["aps"] as! [String: AnyObject]
        
        // 2
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

