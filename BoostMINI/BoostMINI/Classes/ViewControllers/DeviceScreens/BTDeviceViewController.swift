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
    
    @IBOutlet weak var stickImage: UIImageView!
    
    @IBOutlet weak var imageTicketView: ConcertInfoView!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var scanErrorBtn: UIButton!
    @IBOutlet weak var connectionErrorBtn: UIButton!
    
    var disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.titleLbl.text = RDevice.btTitleLbl()
        self.cancelBtn.setTitle(RCommon.cancel(), for: .normal)
        self.confirmBtn.setTitle(RCommon.ok(), for: .normal)
        self.resetBtn.setTitle(RDevice.btReSettingBtn(), for: .normal)
        self.registerBtn.setTitle(RDevice.btTitleLbl(), for: .normal)
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
    
    func initViewManagement(reactor: DeviceViewReactor) -> Bool {
        if reactor.viewType == .initialize { return false }
        
        self.rx.viewDidAppear
            .map { _ in Reactor.Action.manageMentInit }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.resetBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                BSTFacade.ux.showConfirm(RDevice.btConfirmReset(), title: nil, { (isOk) in
                    guard let isOk = isOk else { return }
                    if isOk {
                        BSTFacade.ux.goTicketScan(currentViewController: self)
                        reactor.action.onNext(.clearDevice)
                    }
                })
            })
            .disposed(by: self.disposeBag)
        
        self.registerBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                BSTFacade.ux.goTicketScan(currentViewController: self)
            })
            .disposed(by: self.disposeBag)
        
        let isConnected = BSTFacade.device.isConnected
        
        self.stickImage.alpha = isConnected ? 1.0 : 0.3
        self.registerBtn.isHidden = isConnected
        self.imageTicketView.isHidden = !isConnected
        self.resetBtn.isHidden = !isConnected
        
        self.cancelBtn.isHidden = true
        self.confirmBtn.isHidden = true
        
        self.registerBtn.backgroundColor = R.clr.boostMini.commonBgPoint()
        
        return true
    }
    
    func bind(reactor: DeviceViewReactor) {
        
        if self.initViewManagement(reactor: reactor) == false {
            self.resetBtn.isHidden = true
            self.registerBtn.isHidden = true
            self.backBtn.isHidden = true
            self.scanErrorBtn.isHidden = false
            self.connectionErrorBtn.isHidden = false
            
            self.rx.viewDidAppear
                .map { _ in Reactor.Action.connectAll }
                .bind(to: reactor.action)
                .disposed(by: self.disposeBag)
            
            reactor.state.map { $0.isParingDevice }
                .distinctUntilChanged()
                .bind(to: self.cancelBtn.rx.isHidden)
                .disposed(by: self.disposeBag)
            
            reactor.state.map { !$0.isParingDevice }
                .distinctUntilChanged()
                .bind(to: self.confirmBtn.rx.isHidden)
                .disposed(by: self.disposeBag)
        }
        
        reactor.state.map { $0.contentMsg.content }
            .bind(to: self.contentLbl.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.titleMsg }
            .distinctUntilChanged()
            .bind(to: self.titleLbl.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isParingDevice }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { _ in
                self.blinkImage()
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.deviceError }
            .filterNilKeepOptional()
            .subscribe(onNext: { error in
                self.stickImage.alpha = 0.3
                error?.cookError()
            })
            .disposed(by: self.disposeBag)
        
        self.scanErrorBtn.rx.tap.map { _ in Reactor.Action.errorScan }.bind(to: reactor.action).disposed(by: self.disposeBag)
        self.connectionErrorBtn.rx.tap.map { _ in Reactor.Action.errorConnetion }.bind(to: reactor.action).disposed(by: self.disposeBag)
    }
}
