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

    /// ViewController 로딩 시, 프로퍼티 초기화
    private func initProperties() {

    }

    /// ViewController 로딩 시, UIControl 초기화
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
    

    @IBAction func goDevice(_ sender: Any) {
        BSTFacade.go.device(self, type: ReactorViewType.Management)
    }
    
    @IBAction func goToYoutubeSite(_ sender: UIButton) {
        let appURL = NSURL(string: "youtube://www.youtube.com/user/SMTOWN")!
        let webURL = NSURL(string: "https://www.youtube.com/user/SMTOWN")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            // if Youtube app is not installed, open URL inside Safari
            application.open(webURL as URL)
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
