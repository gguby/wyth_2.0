//
//  TicketConfirmViewController.swift
//  BoostMINI
//
//  Created by HS Lee on 16/01/2018.
//  Copyright © 2018 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit

class TicketConfirmViewController: UIViewController {

    // MARK: - * properties --------------------
    let disposeBag = DisposeBag()

    // MARK: - * IBOutlets --------------------
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ticketView: ConcertInfoView!
    @IBOutlet weak var btnConnect: UIButton! {
        didSet {
            self.btnConnect.rx.tap
                .subscribe(onNext: { [weak self] _ in
//                    self?.navigationController?.popViewController(animated: true)
                    BSTFacade.ux.goDevice(self, type: ReactorViewType.initialize)
                })
                .disposed(by: disposeBag)
        }
    }
    
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
        scrollView.contentSize = self.view.bounds.size
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


extension TicketConfirmViewController {

}
