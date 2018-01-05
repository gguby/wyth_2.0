//
//  NotificationViewController.swift
//  BoostMINI
//
//  Created by HS Lee on 27/12/2017.
//Copyright © 2017 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit
import ReactorKit
import RxCocoa
import RxSwift

protocol NotificationView: class {
    func setNotifications(notifications: [NotificationModel])
}

//protocol NotificationViewPresenter {
//    init(view: NotificationView, notifications: [NotificationModel])
//    func updateNotifications()
//}

class NotificationPresenter {

    unowned let view: NotificationView
    var notifications: [NotificationModel]?
//    let notification: NotificationModel?
    
    required init(view: NotificationView) {
        self.view = view
    }
    
    func updateNotifications() {
        //reqeust api
//        notifications = NotificationModel.getList() { results in
//            self.view.setNotifications(notifications: notifications!)
//        }
    }
}


class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnExpand: UIButton!
}


class NotificationViewController: UIViewController, NotificationView {
    
    // MARK: * properties --------------------
//    let viewModel = NotificationViewModel()
    var presenter: NotificationPresenter?
    var disposeBag = DisposeBag()
    
    // MARK: * IBOutlets --------------------

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: * Initialize --------------------

    override func viewDidLoad() {

        self.initProperties()
        self.initUI()
        self.prepareViewDidLoad()
    }


    private func initProperties() {
        self.presenter = NotificationPresenter(view: self)
    }


    private func initUI() {

    }


    func prepareViewDidLoad() {
        self.presenter?.updateNotifications()
    }

    // MARK: * Main Logic --------------------
    func setNotifications(notifications: [NotificationModel]) {
        
        let data = Observable<[NotificationModel]>.just(notifications)
        data.bind(to: tableView.rx.items(cellIdentifier: "NotificationTableViewCell", cellType: NotificationTableViewCell.self)) { indexPath, notification, cell in
            cell.lblTitle.text = notification.title
        }.disposed(by: disposeBag)
    }

    // MARK: * UI Events --------------------


    // MARK: * Memory Manage --------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


