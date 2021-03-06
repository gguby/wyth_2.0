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
    func setNotifications(notifications: [NoticeList])
}

//protocol NotificationViewPresenter {
//    init(view: NotificationView, notifications: [NotificationModel])
//    func updateNotifications()
//}
extension NoticeList {
    
    /// 읽음 처리
    func updateReadStatus() {
        if self.view == false {
            DefaultAPI.postNoticesReadUsingPOST(id: self.id?.i ?? 0, read: true, completion: { (error) in
                self.view = error == nil
            })
        }
    }
}

class NotificationPresenter {

    unowned let view: NotificationView
    var notices: [NoticeList]?
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
    @IBOutlet weak var imgvNew: UIImageView!
    
    var notice: NoticeList? {
        didSet {
            guard let notice = notice else {
                return
            }
            
            self.lblTitle.text = notice.title
            self.lblContent.text = notice.expand ? notice.content : ""
            self.lblContent.getConstraint(attribute: .bottom)?.constant = notice.expand ? 16.c : 0.c
            
            let textColor = notice.expand ? BSTFacade.theme.color.commonTextBg() : BSTFacade.theme.color.textSubtext1()
            imgvNew.isHidden = (notice.view ?? true) || notice.expand
            
			let angle = (notice.expand ? 180 : 0).c.toRadians
            UIView.animate(withDuration: 0.25) {
                self.lblTitle.textColor = textColor
                self.lblContent.textColor = textColor
                
                self.imgvExpand.transform = CGAffineTransform(rotationAngle: angle)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
}


class NotificationViewController: BoostUIViewController, NotificationView {
    
    // MARK: * properties --------------------
    var presenter: NotificationPresenter?
    var disposeBag = DisposeBag()
    var isFirstLoading = true
    var footer: DefaultRefreshFooter?
    
    // MARK: * IBOutlets --------------------
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.estimatedRowHeight = 50
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

    
    fileprivate func initLoadmoreUI() {
        footer = DefaultRefreshFooter.footer()
        
        guard let footer = footer else { return }
        
        footer.spinner.activityIndicatorViewStyle = .white
        footer.setText("", mode: .pullToRefresh)
        footer.setText("", mode: .refreshing)
        
        self.tableView.configRefreshFooter(with: footer) {
            footer.spinner.center = CGPoint(x: self.view.bounds.width / 2.c, y: self.tableView.estimatedRowHeight / 2.c)
            self.presenter?.updateNotifications(lastId: self.notifications.reversed().first?.id?.i, size: BSTConstants.main.pageSize)
        }
    }
    
    /// ViewController 로딩 시, UIControl 초기화
    private func initUI() {
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            var notice = self?.notifications[indexPath.row]
            notice?.reverseExpand()
            notice?.updateReadStatus()
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }


    func prepareViewDidLoad() {
        self.presenter?.updateNotifications(lastId: nil, size: BSTConstants.main.pageSize)
    }

    var notifications: [NoticeList] = []
    // MARK: * Main Logic --------------------
    func setNotifications(notifications: [NoticeList]) {
        
        if notifications.count > 0, footer == nil {//최초 실행 후, 알림이 있을 경우,
            self.initLoadmoreUI()
        }
        
        self.notifications.append(contentsOf: notifications)
        self.tableView.reloadData()
        
        if self.notifications.count % BSTConstants.main.pageSize > 0 {
            self.tableView.switchRefreshFooter(to: .removed)
        }
    }

    // MARK: * UI Events --------------------


    // MARK: * Memory Manage --------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if let tcell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as? NotificationTableViewCell {
            
            var notice = self.notifications[indexPath.row]
            
            if let deepLink = BSTFacade.session.deepLink, let comp = deepLink.query?.components(separatedBy: "=").last,
                let pushId = Int(comp), isFirstLoading, pushId == notice.pushId?.i {
                    notice.reverseExpand()
                    notice.updateReadStatus()
                
                    BSTFacade.session.deepLink = nil    //푸시 링크 초기화
                    isFirstLoading = false              //최초 로딩시 플래그 초기화,
            }
            
            tcell.notice = notice
            
            cell = tcell
        }
        
        return cell ?? UITableViewCell()
    }
}


