//
//  DeviceManager.swift
//  BoostMINI
//
//  Created by wsjung on 2017. 12. 29..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import RxSwift
import RxBluetoothKit
import CoreBluetooth

final class DeviceManager {
    
    var reactor : DeviceManagerReactor

    static var isConnectedObserver : PublishSubject<Bool> {
        return PublishSubject<Bool>()
    }
    static var registeredDeviceObserver : PublishSubject<BSTLocalDevice> {
        return PublishSubject<BSTLocalDevice>()
    }
    
    var isConnected = false
    var registeredDevice : BSTLocalDevice?
    
    let disposeBag = DisposeBag()
    
    init() {
        self.reactor = DeviceManagerReactor.init(service: BTDeviceService.init(), network: BTDeviceNetwork.init())
        self.bind()
    }
    
    func bind() {
        DeviceManager.isConnectedObserver.subscribe(onNext: {
            self.isConnected = $0
        }).disposed(by: disposeBag)
        
        DeviceManager.registeredDeviceObserver.subscribe(onNext: {
            self.registeredDevice = $0
        }).disposed(by: disposeBag)
    }
}
