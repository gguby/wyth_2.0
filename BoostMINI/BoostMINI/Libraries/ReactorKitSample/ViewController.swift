//
//  ViewController.swift
//  reactorKitSample
//
//  Created by wsjung on 2017. 12. 14..
//  Copyright © 2017년 wsjung. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit
import SafariServices

class ViewController: UIViewController, StoryboardView {
    
    typealias Reactor = ViewControllerReactor
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController.init(searchResultsController: nil)
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.scrollIndicatorInsets.top = tableView.contentInset.top
        searchController.dimsBackgroundDuringPresentation = false
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func bind(reactor: ViewControllerReactor) {
        searchController.searchBar.rx.text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .map { Reactor.Action.updateQuery($0)}
            .bind(to: reactor.action )
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.repos }
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) {
                indexPath, repos, cell in
                    cell.textLabel?.text = repos.fullName
            }.disposed(by: disposeBag)
        
        tableView.rx.contentOffset
            .filter { [weak self] offset in
                guard let `self` = self else { return false }
                guard self.tableView.frame.height > 0 else { return false }
                return offset.y + self.tableView.frame.height >= self.tableView.contentSize.height - 100
            }
            .map { _ in Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self, weak reactor] indexPath in
                guard let `self` = self else { return }
                self.view.endEditing(true)
                self.tableView.deselectRow(at: indexPath, animated: false)
                guard let repo = reactor?.currentState.repos[indexPath.row].fullName else { return }
                guard let url = URL(string: "https://github.com/\(repo)") else { return }
                let viewController = SFSafariViewController(url: url)
                self.searchController.present(viewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

