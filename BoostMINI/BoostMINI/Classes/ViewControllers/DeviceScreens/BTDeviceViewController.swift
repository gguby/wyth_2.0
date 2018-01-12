//
//  BTDeviceViewController.swift
//  BoostMINI
//
//  Created by wsjung on 2018. 1. 8..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import RxViewController

class BTDeviceViewController : UIViewController, StoryboardView {
    
    typealias RDevice = R.string.device
    typealias RCommon = R.string.common
    
    typealias Reactor = DeviceViewReactor
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var stickImage: UIImageView!    
    
    @IBOutlet weak var imageTicketView: ConcertInfoView!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.titleLbl.text = RDevice.btTitleLbl()
        self.cancel.setTitle(RCommon.cancel(), for: .normal)
        self.stickImage.alpha = 0.3
    }
    
    func blinkImage() {
        
        guard let normalImage = R.image.imgStickImg()?.image(alpha: 0.3) else { return }
        guard let blinkImage = R.image.imgStickImg() else { return }
        
        let images : [UIImage] = [normalImage, blinkImage, normalImage, blinkImage]
        
        self.stickImage.animationImages = images
        self.stickImage.animationDuration = 0.5
        self.stickImage.animationRepeatCount = 2
        self.stickImage.startAnimating()
        
        self.stickImage.alpha = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bind(reactor: DeviceViewReactor) {
        
        self.rx.viewDidAppear
            .map { _ in Reactor.Action.connectAll }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.cancel.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.contentMsg.content }
            .bind(to: self.contentLbl.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isParingDevice }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { _ in                 
                self.blinkImage()
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.deviceError }
            .filterNilKeepOptional()
            .subscribe(onNext: { error in
                error?.cookError()
            })
            .disposed(by: disposeBag)
    }
    
}
