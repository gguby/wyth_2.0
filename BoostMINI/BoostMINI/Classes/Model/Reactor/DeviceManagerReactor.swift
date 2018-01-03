//
//  DeviceManagerReactor.swift
//  BoostMINI
//
//  Created by wsjung on 2017. 12. 29..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

//mkdir -p ~/Library/Developer/Xcode/Templates/Custom

//콘솔에서 cp -R /Applications/Xcode.app/Contents/Developer/Library/Xcode/Templates/File\ Templates/Source/Swift\ File.xctemplate/ ~/Library/Developer/Xcode/Templates/Custom/Moya\ File.xctemplate 입력후 파일 교체

import Foundation
import ReactorKit
import RxCocoa
import RxSwift
import CoreBluetooth
import RxBluetoothKit

final class DeviceManagerReactor : Reactor {
    
    enum Action {
        case scanDevice
        case pairingDevice(ScannedPeripheral)
        case blinkLight
        case writeCode
        case registerDevice
    }
    
    enum Mutation {
        case scanDevice(Bool)
        case setDiscoverDevice([ScannedPeripheral])
        case paringDevice(Bool)
        case setActiveDevice(Peripheral)
        case setCharacteristic(Characteristic)
        case setWriteCode(String)
        case blinkLight(Bool)
        case registerDevice(Bool)
    }
    
    struct State {
        var isScanDevice : Bool = false
        var isParingDevice : Bool = false
        var discoverPeripherals : [ScannedPeripheral]?
        var activePeripheral : Peripheral?
        var characteristic : Characteristic?
        var writeCode : String?
        var isBlink : Bool = false
        var isRegister : Bool = false
    }
    
    let initialState = State()
    
    fileprivate let service : BTDeviceService
    fileprivate let network : BTDeviceNetwork
    
    init(service : BTDeviceService, network : BTDeviceNetwork) {
        self.service = service
        self.network = network
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .scanDevice:
            
            let startScan = Observable<Mutation>.just(.scanDevice(true))
            let stopScan = Observable<Mutation>.just(.scanDevice(false))
            let setDevice = self.service.startScan().map {Mutation.setDiscoverDevice($0)}
            return Observable.concat([startScan, setDevice, stopScan])
            
        case let .pairingDevice(peripheral):
            
            let paring = Observable<Mutation>.just(.paringDevice(true))
            let setActiveDevice = self.service.connect(scannedPeripheral: peripheral).map { Mutation.setActiveDevice($0) }
            let setCharacteristic = self.service.setChracteristic(scannedPeripheral: peripheral).map { Mutation.setCharacteristic($0) }
            
            return Observable.concat([paring, setActiveDevice, setCharacteristic])
            
        case .blinkLight :
            return Observable.just(Mutation.scanDevice(false))
        case .writeCode :
            return Observable.just(Mutation.scanDevice(false))
        case .registerDevice :
            return Observable.just(Mutation.scanDevice(false))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var newState = state
        
        switch mutation {
        case let .scanDevice(isScan):
            newState.isScanDevice = isScan
        case let .setDiscoverDevice(scanDeviceList):
            newState.discoverPeripherals = scanDeviceList
        case let .paringDevice(paring):
            newState.isParingDevice = paring
        case let .setActiveDevice(activePeripheral):
            newState.activePeripheral = activePeripheral
        case let .setCharacteristic(characteristic):
            newState.characteristic = characteristic
        case let .blinkLight(blink):
            newState.isBlink = blink
        case let .setWriteCode(code):
            newState.writeCode = code
        case let .registerDevice(isRegister):
            newState.isRegister = isRegister
        }

        return newState
    }
}
