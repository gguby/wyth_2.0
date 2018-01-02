//
//  HomeViewController.swift
//  BoostMINI
//
//  Created by  KoMyeongbu on 2017. 12. 27..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

class HomeViewController: UIViewController {

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
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.default.menuPresentMode = .menuSlideIn
    }


    private func initUI() {
        
    }


    func prepareViewDidLoad() {

    }

    // MARK: - * Main Logic --------------------


    // MARK: - * UI Events --------------------
    
    @IBAction func gotoInformationViewController(_ sender: UIButton) {
        let vc = ConcertInformationViewController()
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
        
    }
    

    // MARK: - * Memory Manage --------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension HomeViewController {

}
