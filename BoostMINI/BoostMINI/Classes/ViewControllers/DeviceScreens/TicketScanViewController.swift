//
//  TicketScanViewController.swift
//  BoostMINI
//
//  Created by HS Lee on 10/01/2018.
//Copyright © 2018 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit

class TicketScanViewController: UIViewController {

    // MARK: - * properties --------------------
    var disposeBag = DisposeBag()

    // MARK: - * IBOutlets --------------------

    @IBOutlet weak var btnBack: UIButton! {
        willSet(v) {
            v.rx.tap.bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        }
    }
    
    // MARK: - * Initialize --------------------

    override func viewDidLoad() {

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


    // MARK: - * Memory Manage --------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension TicketScanViewController {

}
