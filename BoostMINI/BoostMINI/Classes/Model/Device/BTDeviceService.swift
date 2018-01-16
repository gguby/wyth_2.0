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
    
    private let boostServiceUUID = CBUUID(string: Definitions.device.service_UUID)
    private let boostCharacteristicUUID = CBUUID(string: Definitions.device.characteristic_UUID)
    
    let DeviceKey = "boostDevice"
    
    init() {}
    
//    func retrieve() {
//        self.manager.retrieveConnectedPeripherals(withServices: [boostServiceUUID])
//            .subscribe { (event) in
//                print(event)
//            }.disposed(by: disposeBag)
//    }
    
    func scanner() -> Observable<[ScannedPeripheral]> {
        return self.manager
            .rx_state
            .debug()
            .filter { $0 == .poweredOn }
            .timeout(4.0, scheduler: MainScheduler.instance)
            .take(1)
            .flatMap { _ in self.manager.scanForPeripherals( withServices: [self.boostServiceUUID]) }
            .take(3.0, scheduler: MainScheduler.instance)
            .toArray()
    }
    
    func scan(observable : Observable<[ScannedPeripheral]>) -> Observable<Bool> {
        return observable
            .flatMap({ (scannedPeripherals) -> Observable<Bool> in
                return scannedPeripherals.isEmpty ? .just(false) : .just(true)
            })
    }
    
    func paring(observable : Observable<[ScannedPeripheral]>) -> Observable<Bool> {
        return self.connect(observable: observable)
            .flatMap ({ (peripheral) -> Observable<Bool> in
                peripheral.isConnected ? .just(true) :  .just(false)
            })
    }
    
    func connect(observable : Observable<[ScannedPeripheral]>) -> Observable<Peripheral> {
         return observable
            .map {
                return $0.sorted(by: { (lhs, rhs) -> Bool in
                    return lhs.rssi.doubleValue > rhs.rssi.doubleValue
                })
            }
            .flatMap {
                Observable.from($0)
            }
            .take(1)
            .do(onNext: { ScannedPeripheral in
                logVerbose("Discovered ScannedPeripheral: \(ScannedPeripheral)")
            })
            .flatMap { $0.peripheral.connect() }
//            .do(onNext: { Peripheral in
//                logVerbose("Discovered Peripheral: \(Peripheral)")
//            }
//            .debug()
//            .flatMap { $0.discoverServices([self.boostServiceUUID])}
//            .flatMap { Observable.from($0) }
//            .flatMap { $0.discoverCharacteristics([self.boostCharacteristicUUID])}
//            .flatMap { Observable.from($0) }
//            .do(onNext: { characteristic in
//                logVerbose("Discovered characteristic: \(characteristic)")
//            })
//            .subscribeOn(MainScheduler.instance)
    }
    
    func register(observable : Observable<Peripheral>) -> Observable<Bool> {
        return observable.flatMap { peripheral in
            return self.saveDevice(device: peripheral)
        }
    }

    func disconnectDevice(scannedPeripheral : ScannedPeripheral) -> Observable<Peripheral> {
        return self.manager.monitorDisconnection(for: scannedPeripheral.peripheral)
    }
    
    private func saveDevice(device : Peripheral?) -> Observable<Bool> {
        
        guard let device = device else { return .just(false) }
        
        let name = device.name
        let uuid = device.identifier.uuidString
        let dict = [name, uuid]
        
        print("Save Device")
        print(dict)
        
        UserDefaults.standard.set(dict, forKey: DeviceKey)
        let isOk = UserDefaults.standard.synchronize()
        return .just(isOk)
    }
    
    func loadDevice() -> BSTLocalDevice? {
        let array = UserDefaults.standard.array(forKey: DeviceKey) as? [String]
        guard let arr = array else { return nil }
        let localDevice = BSTLocalDevice.init(array: arr)
        return localDevice
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
