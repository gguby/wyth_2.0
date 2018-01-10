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

    @IBOutlet weak var tiltingView: TopTiltingView!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(tiltingView.isHidden){
            showStartAnimation()
        }
    }

    // MARK: - * Main Logic --------------------
    func showStartAnimation() {
        tiltingView.isHidden = false
    }

    // MARK: - * UI Events --------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

    // MARK: - * Memory Manage --------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension MenuViewController {

}
