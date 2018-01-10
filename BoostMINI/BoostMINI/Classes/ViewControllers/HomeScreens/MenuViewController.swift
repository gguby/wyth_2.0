//
//  MenuViewController.swift
//  BoostMINI
//
//  Created by  KoMyeongbu on 2018. 1. 8..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {

    // MARK: - * properties --------------------


    // MARK: - * IBOutlets --------------------

    @IBOutlet weak var diagonalImageView: UIImageView!
    
    
    // MARK: - * Initialize --------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initProperties()
        self.initUI()
        self.prepareViewDidLoad()
    }


    private func initProperties() {

    }


    private func initUI() {
        diagonalImageView.transform = diagonalImageView.transform.rotated(by: CGFloat.init(M_PI))
    }


    func prepareViewDidLoad() {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

    // MARK: - * Main Logic --------------------
    
    // MARK: - * UI Events --------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "deviceSegue" {
            if let vc  = segue.destination as? BTDeviceViewController {
                let reactor = DeviceViewReactor.init(service: BTDeviceService.init())
                vc.reactor = reactor
            }
        }
    }
    

    // MARK: - * Memory Manage --------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension MenuViewController {

}
