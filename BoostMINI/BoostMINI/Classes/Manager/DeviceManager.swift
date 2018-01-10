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
    
    var isConnectedObserver = PublishSubject<Bool>()
    
    var registeredDeviceObserver = PublishSubject<BSTLocalDevice>()
    
    var error = PublishSubject<DeviceError>()
    
    var isConnected = false
    var registeredDevice : BSTLocalDevice?
    
    let disposeBag = DisposeBag()
    
    init() {
        self.bind()
    }
    
    func bind() {
        self.isConnectedObserver.subscribe(onNext: {
            self.isConnected = $0
        }).disposed(by: disposeBag)
        
        self.registeredDeviceObserver.subscribe(onNext: {
            self.registeredDevice = $0
        }).disposed(by: disposeBag)
        
        self.error.subscribe(onNext: {
            print($0)           
            
        }).disposed(by: disposeBag)
    }
    
    func receiveError(error: DeviceError) {
        self.error.onNext(error)
    }
}

enum DeviceError : Error, BSTErrorProtocol {
    
    case scanFailed
    case paringFailed
    
    func cook(_ object: Any? = nil) {
        if object == nil {
//            BSTFacade.device.reactor.mutate(action: DeviceManagerReactor.Action.scanDevice)
//            BSTFacade.ux.gotoErrorPage()
        } else {
            BSTFacade.ux.showAlert(self.description)
//            BSTFacade.ux.gotoErrorPage()
        }
    }
}

extension DeviceError {
    
    var key : String {
        switch self {
        case .scanFailed:
            return "deviceScanFailed"
        case .paringFailed:
            return "deviceParingFailed"
        }
    }
    
    var title: String! {
        return self.key
    }
    
    var code : Int {
        switch self {
        case .scanFailed:
            return 700
        case .paringFailed:
            return 701
        }
    }
    
    var description: String { return self.localizedDescription }
    var localizedDescription: String { return NSLocalizedString(self.key, comment: "") }
}
