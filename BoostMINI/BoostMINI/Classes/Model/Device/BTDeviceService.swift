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
    
    let disposeBag = DisposeBag()
    
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
            .take(1.0, scheduler: MainScheduler.instance)
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
    }
    
    func chrateristic(observable : Observable<Peripheral>) -> Observable<Characteristic> {
        return observable
            .flatMap { $0.discoverServices([self.boostServiceUUID])}
            .flatMap { Observable.from($0) }
            .do(onNext: { Service in
                logVerbose("Discovered Service: \(Service)")
            })
            .flatMap { $0.discoverCharacteristics([self.boostCharacteristicUUID])}
            .flatMap { Observable.from($0) }
            .do(onNext: { Characteristic in
                logVerbose("Discovered Characteristic: \(Characteristic)")
            })
    }
    
    func register(observable : Observable<Peripheral>) -> Observable<Bool> {
        return observable.flatMap { peripheral in
            return self.saveDevice(device: peripheral)
        }
    }

    func disconnectDevice(scannedPeripheral : ScannedPeripheral) -> Observable<Peripheral> {
        return self.manager.monitorDisconnection(for: scannedPeripheral.peripheral)
    }
}

extension BTDeviceService {
    private func saveDevice(device : Peripheral?) -> Observable<Bool> {
        
        guard let device = device else { return .just(false) }
        
        let name = device.name
        let uuid = device.identifier.uuidString
        let userName = BSTFacade.session.name
        let dict = [userName, name, uuid]
        
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

extension BTDeviceService {
    
    func writeValueForCharacteristic(hexadecimalString: String, characteristic: Characteristic) {
        let hexadecimalData: Data = Data.fromHexString(string: hexadecimalString)
        let type: CBCharacteristicWriteType = characteristic.properties.contains(.write) ? .withResponse : .withoutResponse
        characteristic.writeValue(hexadecimalData as Data, type: type)
            .subscribe(onNext: { _ in
                
            }).disposed(by: disposeBag)
    }
    
    func triggerValueRead(for characteristic: Characteristic) {
        characteristic.readValue()
            .subscribe(onNext: { _ in
                
            }).disposed(by: disposeBag)
    }
}

struct BSTLocalDevice {
    let deviceName : String!
    let userName : String!
    let uuid : UUID!
    
    init(array : [String]) {
        self.userName = array[0]
        self.deviceName = array[1]
        self.uuid = UUID.init(uuidString: array[2])
    }
}

extension Data {
    
    /// Return hexadecimal string representation of NSData bytes
    var hexadecimalString: String {
        var bytes = [UInt8](repeating: 0, count: count)
        copyBytes(to: &bytes, count: count)
        
        let hexString = NSMutableString()
        for byte in bytes {
            hexString.appendFormat("%02x", UInt(byte))
        }
        return NSString(string: hexString) as String
    }
    
    // Return Data represented by this hexadecimal string
    static func fromHexString(string: String) -> Data {
        var data = Data(capacity: string.count / 2)
        
        do {
            let regex = try NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
            regex.enumerateMatches(in: string, options: [], range: NSMakeRange(0, string.count)) { match, _, _ in
                if let _match = match {
                    let byteString = (string as NSString).substring(with: _match.range)
                    if var num = UInt8(byteString, radix: 16) {
                        data.append(&num, count: 1)
                    }
                }
            }
        } catch {
        }
        
        return data
    }
}
