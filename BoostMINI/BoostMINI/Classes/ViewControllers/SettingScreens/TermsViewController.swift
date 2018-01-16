//
//  TermsViewController.swift
//  BoostMINI
//
//  Created by  KoMyeongbu on 2018. 1. 8..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit

class TermsViewController: UIViewController {

    // MARK: - * properties --------------------


    // MARK: - * IBOutlets --------------------
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var leftMotiveImageView: UIImageView!
    @IBOutlet weak var rightMotiveImageView: UIImageView!
    
    @IBOutlet weak var termsTabBarItem: UITabBarItem!
    @IBOutlet weak var privacyTabBarItem: UITabBarItem!
    
    // MARK: - * Initialize --------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initProperties()
        self.initUI()
        self.prepareViewDidLoad()
    }

    /// ViewController 로딩 시, 프로퍼티 초기화
    private func initProperties() {

    }

    /// ViewController 로딩 시, UIControl 초기화
    private func initUI() {
        self.tabBar.selectedItem = termsTabBarItem
    }


    func prepareViewDidLoad() {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
    }

    // MARK: - * Main Logic --------------------
    func pop() {
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


extension TermsViewController : UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let items = tabBar.items else { return }
        if items.index(of: item) == 0 {
            self.leftMotiveImageView.isHidden = false
            self.rightMotiveImageView.isHidden = true
        } else {
            self.leftMotiveImageView.isHidden = true
            self.rightMotiveImageView.isHidden = false
        }
    }
}
