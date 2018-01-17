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

    class func requestDeterminingPermission(completion: BSTClosure.emptyAction?) {
        
        let permissionSet = PermissionSet(Permission.defaultSet)
        var isPermissionRequesting = false
        
        let queue = DispatchQueue.global(qos: .default)
        let dispatchGroup = DispatchGroup()
        
        for (index, permission) in permissionSet.permissions.enumerated() {
            dispatchGroup.enter()  //  Enter the dispatch group
            
            queue.async(group: dispatchGroup, execute: {
                if permission.status == .notDetermined {//권한 체크 이력 확인,
                    isPermissionRequesting = true
                    
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
}
