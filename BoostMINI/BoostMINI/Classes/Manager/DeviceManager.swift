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

    var isConnectedObserver = PublishSubject<Bool>()
    
    var registeredDeviceObserver = PublishSubject<BSTLocalDevice>()
    
    var error = PublishSubject<DeviceError>()
    
    var isConnected = false
    var registeredDevice : BSTLocalDevice?
    
    let disposeBag = DisposeBag()
    
    init() {
        self.reactor = DeviceManagerReactor.init(service: BTDeviceService.init())
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
}

enum DeviceError : String, Error, BSTErrorProtocol {
    case scanFailed = "deviceScanFailed"
    case paringFailed = "deviceParingFailed"
    
    var description: String {
        var description = ""
        switch self {
        case .scanFailed:
            description = BSTFacade.localizable.error.deviceScanFailed()
        case .paringFailed:
            description = BSTFacade.localizable.error.deviceParingFailed()
        default:
            break
        }
        return description
    }
    
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
    var title: String! {
        return self.rawValue
    }
    
    var code : Int {
        switch self {
        case .scanFailed:
            return 700
        case .paringFailed:
            return 701
        }
    }
    
    var localizedDescription: String { return NSLocalizedString(self.rawValue, comment: "") }
}
