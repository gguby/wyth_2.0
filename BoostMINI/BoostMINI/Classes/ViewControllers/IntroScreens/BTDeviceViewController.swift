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
        
        self.navigationController?.isNavigationBarHidden = true
        self.titleLbl.text = RDevice.btTitleLbl()
        self.contentLbl.text = RDevice.btContentScan()
        self.cancel.setTitle(RCommon.cancel(), for: .normal)
        self.stickImage.alpha = 0.3
        
        self.blinkImage()
    }
    
    func blinkImage() {
        
        guard let normalImage = R.image.imgStickImg()?.image(alpha: 0.3) else { return }
        guard let blinkImage = R.image.imgStickImg() else { return }
        
        let images : [UIImage] = [normalImage, blinkImage, normalImage, blinkImage]
        
        self.stickImage.animationImages = images
        self.stickImage.animationDuration = 0.5
        self.stickImage.animationRepeatCount = 2
        self.stickImage.startAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bind(reactor: DeviceViewReactor) {
        
        self.cancel.rx.tap
            .subscribe(onNext: { [weak self] event in
                print(event)
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.contentMsg.content }
            .bind(to: self.contentLbl.rx.text)
            .disposed(by: disposeBag)
    }
    
}
