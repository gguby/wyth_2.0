//
//  BTDeviceService.swift
//  BoostMINI
//
//  Created by wsjung on 2017. 12. 29..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

import Foundation
import RxSwift
import RxBluetoothKit
import CoreBluetooth

class BTDeviceService {
    
    private let manager = BluetoothManager.init(queue: .main, options: nil)
    private var scheduler: ConcurrentDispatchQueueScheduler!
    
    private let boostServiceUUID = CBUUID(string: Definitions.device.service_UUID)
    private let boostCharacteristicUUID = CBUUID(string: Definitions.device.characteristic_UUID)
    
    let DeviceKey = "boostDevice"
    
    init() {
        let timerQueue = DispatchQueue(label: "com.iriver.boostmini.device.timer")
        scheduler = ConcurrentDispatchQueueScheduler(queue: timerQueue)
    }
 
    func startScan() -> Observable<[ScannedPeripheral]> {
        return self.manager
            .rx_state
            .filter { $0 == .poweredOn }
            .timeout(4.0, scheduler: self.scheduler)
            .take(1)
            .flatMap { _ in self.manager.scanForPeripherals( withServices: [self.boostServiceUUID]) }
            .subscribeOn(MainScheduler.instance)
            .toArray()
    }
    
    func connect(scannedPeripheral : ScannedPeripheral) -> Observable<Peripheral> {
        return self.manager.connect(scannedPeripheral.peripheral)
    }
    
    func setService(scannedPeripheral : ScannedPeripheral) -> Observable<Service> {
        return self.connect(scannedPeripheral: scannedPeripheral)
            .flatMap { $0.discoverServices([self.boostServiceUUID]) }
            .flatMap {Observable.from($0)}
    }
    
    func setChracteristic(scannedPeripheral : ScannedPeripheral) -> Observable<Characteristic> {
        return self.setService(scannedPeripheral: scannedPeripheral)
            .flatMap { $0.discoverCharacteristics([self.boostCharacteristicUUID])}
            .flatMap { Observable.from($0)}
    }
    
    func disconnectDevice(scannedPeripheral : ScannedPeripheral) -> Observable<Peripheral> {
        return self.manager.monitorDisconnection(for: scannedPeripheral.peripheral)
    }
    
    func saveDevice(device : Peripheral?) -> Observable<Bool> {
        
        guard let device = device else { return Observable.empty() }
        
        let name = device.name
        let uuid = device.identifier.uuidString
        let dict = [name, uuid]
        
        UserDefaults.standard.set(dict, forKey: DeviceKey)
        let isOk = UserDefaults.standard.synchronize()
        return Observable.just(isOk)
    }
    
    func loadDevice() -> BSTLocalDevice? {
        let array = UserDefaults.standard.array(forKey: DeviceKey) as? [String]
        if array == nil { return nil }
        let device = BSTLocalDevice.init(array: array!)
        
        DeviceManager.registeredDeviceObserver.onNext(device)
        
        return device
    }
}

struct BSTLocalDevice {
    let name : String!
    let uuid : UUID!
    
    init(array : [String]) {
        self.name = array[0]
        self.uuid = UUID.init(uuidString: array[1])
    }
}
