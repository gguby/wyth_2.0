//
//  BTDeviceViewController.swift
//  BoostMINI
//
//  Created by wsjung on 2018. 1. 8..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit


class BTDeviceViewController : UIViewController {
    
    typealias RDevice = R.string.device
    typealias RCommon = R.string.common
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    @IBOutlet weak var cancel: UIButton!
    
    @IBOutlet weak var stickImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLbl.text = RDevice.btContentScan()
        self.cancel.titleLabel?.text = RCommon.cancel()
        self.contentLbl.text = RDevice.btContentScan()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
