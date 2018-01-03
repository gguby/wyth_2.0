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
    
    enum DeviceEvent {
        case isScanComplete(Bool)
        case isConnected(Bool)
        case connectingDevice(Peripheral?)
    }
    
    static var event : PublishSubject<DeviceEvent> {
        return PublishSubject<DeviceEvent>()
    }
    
    let disposeBag = DisposeBag()
    
    init() {
    }
    
}
