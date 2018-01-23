//
//  NotificationViewController.swift
//  BoostMINI
//
//  Created by HS Lee on 27/12/2017.
//Copyright © 2017 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit
import RxOptional
import PullToRefreshKit

protocol NotificationView: class {
    func setNotifications(notifications: [Notice])
}

//protocol NotificationViewPresenter {
//    init(view: NotificationView, notifications: [NotificationModel])
//    func updateNotifications()
//}

class NotificationPresenter {

    unowned let view: NotificationView
    var notices: [Notice]?
//    let notification: NotificationModel?
    
    required init(view: NotificationView) {
        self.view = view
    }
    
    func updateNotifications(lastId: Int?, size: Int?) {
        //reqeust api
//        notifications = NotificationModel.getList() { results in
//            self.view.setNotifications(notifications: notifications!)
//        }
        DefaultAPI.getNoticesUsingGET(lastId: lastId?.i64, size: size) { [weak self] response, error in
            guard let pageNotice = response, let notices = pageNotice.notices else {
                return
            }
            self?.view.setNotifications(notifications: notices)
        }
    }
}


class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var imgvExpand: UIImageView!
    
    var notice: Notice? {
        didSet {
            guard let notice = notice else {
                return
            }
            
            self.lblTitle.text = notice.title
            self.lblContent.text = notice.expand ? notice.content : ""
            
			let angle = (notice.expand ? 180 : 0).c.toRadians
            UIView.animate(withDuration: 0.3) {
                self.imgvExpand.transform = CGAffineTransform(rotationAngle: angle)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
}


class NotificationViewController: UIViewController, NotificationView {
    
    // MARK: * properties --------------------
    var presenter: NotificationPresenter?
    var disposeBag = DisposeBag()
    
    // MARK: * IBOutlets --------------------

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 52
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.separatorStyle = .none
        }
    }
    
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
        
        let footer = DefaultRefreshFooter.footer()
        footer.spinner.activityIndicatorViewStyle = .white
        footer.setText("", mode: .pullToRefresh)
        
        self.tableView.configRefreshFooter(with: footer) {
            self.presenter?.updateNotifications(lastId: self.notifications.reversed().first?.id?.i, size: BSTConstants.main.pageSize)
        }
        
        Observable<[Notice]?>.of(self.notifications)
            .replaceNilWith([])
            .bind(to: tableView.rx.items(cellIdentifier: "NotificationTableViewCell", cellType: NotificationTableViewCell.self)) { indexPath, notice, cell in
                cell.notice = notice
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            var notice = self?.notifications[indexPath.row]
            notice?.reverseExpand()
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }


    func prepareViewDidLoad() {
        self.presenter?.updateNotifications(lastId: nil, size: BSTConstants.main.pageSize)
//        self.presenter?.updateNotifications(lastId: 0, size: BSTConstants.main.pageSize)
    }

    var notifications: [Notice] = []
    // MARK: * Main Logic --------------------
    func setNotifications(notifications: [Notice]) {
        self.notifications.append(contentsOf: notifications)
        
        if self.notifications.count % BSTConstants.main.pageSize > 0 {
            self.tableView.switchRefreshFooter(to: .removed)
            return
        }
        
        self.tableView.reloadData()
    }

    // MARK: * UI Events --------------------


    // MARK: * Memory Manage --------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


