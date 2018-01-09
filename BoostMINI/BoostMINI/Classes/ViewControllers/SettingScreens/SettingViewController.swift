//
//  SettingViewController.swift
//  BoostMINI
//
//  Created by  KoMyeongbu on 2018. 1. 9..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController: UIViewController {

    // MARK: - * properties --------------------


    // MARK: - * IBOutlets --------------------


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

    }


    func prepareViewDidLoad() {

    }

    // MARK: - * Main Logic --------------------
    func pop()
    {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - * UI Events --------------------
    @IBAction func back(_ sender: UIButton) {
        pop()
    }
    
    // MARK: - * Memory Manage --------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension SettingViewController {

}
