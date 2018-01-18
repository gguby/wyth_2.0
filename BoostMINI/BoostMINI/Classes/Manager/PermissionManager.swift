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

    /// 권한 설정을 요청함.
    class func requestDeterminingPermission(completion: BSTClosure.emptyAction? = nil) {
       
        let permissionSet = PermissionSet(Permission.defaultSet)
        
        let queue = DispatchQueue.global(qos: .default)
        let dispatchGroup = DispatchGroup()
        
        for (_, permission) in permissionSet.permissions.enumerated() {
            dispatchGroup.enter()  //  Enter the dispatch group
            
            queue.async(group: dispatchGroup, execute: {
                if permission.status == .notDetermined {//권한 체크 이력 확인,
                    permission.request({ (status) in  //각 권한별 요청
                        logDebug(status)
                        dispatchGroup.leave() // Exit dispatch group
                    })
                } else {
                    dispatchGroup.leave() // Exit dispatch group
                }
            })
            
            dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                completion?()
            })
        }
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
