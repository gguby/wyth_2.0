                                                                                                                                                                                                                                                              //
//  PermissionManager.swift
//  BoostMINI
//
//  Created by HS Lee on 12/01/2018.
//  Copyright © 2018 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit
import Permission

class PermissionManager {

    /// 앱 설치 후, 최초 권한 설정을 요청함. case = 앱섪치 회원가입, 앱설치 로그인
    class func requestDeterminingPermission(completion: BSTClosure.emptyAction? = nil) {
       
        let permissionSet = PermissionSet(Permission.defaultSet)
//        guard let _ = permissionSet.permissions.filter({ $0.status == .notDetermined }).first else {
//            return
//        }
        
        let queue = DispatchQueue.global(qos: .default)
        let dispatchGroup = DispatchGroup()
        
        for (_, permission) in permissionSet.permissions.enumerated() {
            
            queue.async(group: dispatchGroup, execute: {
                if permission.status == .notDetermined {//권한 체크 이력 확인,
                    dispatchGroup.enter()  //  Enter the dispatch group
                    permission.request({ (status) in  //각 권한별 요청
                        logDebug(status)
                        dispatchGroup.leave() // Exit dispatch group
                    })
                }
            })
        }
        
        
        dispatchGroup.notify(queue: queue, execute: {
            completion?()
        })
    }
    
    ///앱 설정 화면을 로딩함.
    class func openAppPermissionSettings() {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                logDebug("Settings opened: \(success)") // Prints true
            })
        }
    }
}
