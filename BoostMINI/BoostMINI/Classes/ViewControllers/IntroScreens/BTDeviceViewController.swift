//
//  BTDeviceViewController.swift
//  BoostMINI
//
//  Created by wsjung on 2018. 1. 8..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit


class BTDeviceViewController : UIViewController, StoryboardView {
    
    typealias RDevice = R.string.device
    typealias RCommon = R.string.common
    
    typealias Reactor = DeviceViewReactor
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var stickImage: UIImageView!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLbl.text = RDevice.btContentScan()        
        self.contentLbl.text = RDevice.btContentScan()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bind(reactor: DeviceViewReactor) {
        reactor.state.map { $0.contentMsg.content }
            .bind(to: self.contentLbl.rx.text)
            .disposed(by: disposeBag)
    }
    
}
