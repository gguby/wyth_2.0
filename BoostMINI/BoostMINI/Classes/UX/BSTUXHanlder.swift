//
//  BSTUXHanlder
//  BoostMINI
//
//  Created by HS Lee on 21/12/2017.
//  Copyright © 2017 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit

class BSTUXHandlerInstance {
    var view: UIView?
}

class BSTUXHanlder {
    
    // MARK: * properties --------------------

    // MARK: * IBOutlets --------------------

    // MARK: * Initialize --------------------

    init() {
    }

    // MARK: * Main Logic --------------------
    class func showAlert(message: String) {
        SystemAlert.show(nil, message: message)
    }
    
    class func showConfirm(message: String) {
//        BSTUXHanlderinstnta
//
//        fdlksajfdlksm
    }
    
    class func toast(message: String) {
        
    }
}

extension BSTUXHanlder {
}
