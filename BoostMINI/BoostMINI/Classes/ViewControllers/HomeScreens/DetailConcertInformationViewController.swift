//
//  DetailConcertInformationViewController.swift
//  BoostMINI
//
//  Created by  KoMyeongbu on 2018. 1. 10..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit

class DetailConcertInformationViewController: UIViewController {

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


    // MARK: - * UI Events --------------------
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    // MARK: - * Memory Manage --------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension DetailConcertInformationViewController {

}
