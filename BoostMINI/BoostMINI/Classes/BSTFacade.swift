//
//  BSTFacade.swift
//  BoostMINI
//
//  Created by HS Lee on 20/12/2017.
//  Copyright © 2017 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit

class BSTFacade {
    // MARK: - * typedef --------------------
    
    
    // MARK: - * properties --------------------
    static let ux = BSTUXHanlder()
    
    static let device = DeviceManager()
    
    typealias theme = BST.Theme
    typealias localizable = BST.Localizable

    typealias common = CommonUtil
    static let go = BST.PageManager.shared

    static let session = SessionHandler.shared
    // MARK: - * IBOutlets --------------------

    // MARK: - * Initialize --------------------

    private init() {
        
    }

    // MARK: * Main Logic --------------------
}

extension BSTFacade {
}

