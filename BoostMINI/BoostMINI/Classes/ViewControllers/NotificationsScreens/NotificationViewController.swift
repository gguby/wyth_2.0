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
    func setNotifications(notifications: [NoticeViewModel])
}

//protocol NotificationViewPresenter {
//    init(view: NotificationView, notifications: [NotificationModel])
//    func updateNotifications()
//}

class NotificationPresenter {

    unowned let view: NotificationView
    var notices: [NoticeViewModel]?
//    let notification: NotificationModel?
    
    required init(view: NotificationView) {
        self.view = view
    }
    
    func updateNotifications(lastId: Int, size: Int) {
        //reqeust api
//        notifications = NotificationModel.getList() { results in
//            self.view.setNotifications(notifications: notifications!)
//        }
        
        DefaultAPI.getNoticesUsingGET(lastId: lastId.i64, size: Int.max) { [weak self] response, error in
            guard let pageNotice = response, let list = pageNotice.list else {
                return
            }
			
			var converted: [NoticeViewModel] = []
			for notice in list.content ?? [] {
				if let noticeVM = NoticeViewModel.from(notice) {
					converted.append(noticeVM as! NoticeViewModel)
				}
			}
//            self?.view.setNotifications(notifications: list.content)
        }
    }
}


class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var imgvExpand: UIImageView!
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

    /// ViewController 로딩 시, 프로퍼티 초기화
    private func initProperties() {
        self.presenter = NotificationPresenter(view: self)
    }

    /// ViewController 로딩 시, UIControl 초기화
    private func initUI() {

    }


    func prepareViewDidLoad() {
        self.presenter?.updateNotifications(lastId: 0, size: BSTConstants.main.pageSize)
    }

    // MARK: * Main Logic --------------------
    func setNotifications(notifications: [NoticeViewModel]) {
        
        let data = Observable<[NoticeViewModel]>.just(notifications)
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



