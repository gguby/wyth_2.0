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

final class DeviceViewReactor : Reactor {
    
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
        case loadRegisterDevice(BSTLocalDevice?)
        case deviceError(BSTError)
        case contentMsg(ContentMessage)
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
        var registeredDevice : BSTLocalDevice?
        var deviceError : BSTError?
        var contentMsg : ContentMessage = ContentMessage.notScanning
    }
    
    let initialState = State()
    
    fileprivate let service : BTDeviceService
    
    fileprivate let device = BSTFacade.device
    
    init(service : BTDeviceService) {
        self.service = service
        
        if let device = self.service.loadDevice() {
            print(device.name + device.uuid.uuidString)
        }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .scanDevice:
            
            let startScan = Observable<Mutation>.just(.scanDevice(true))
            let stopScan = Observable<Mutation>.just(.scanDevice(false))
            
            do {
                let setDevice = try self.service.startScan().map {Mutation.setDiscoverDevice($0)}
                return Observable.concat([startScan, setDevice, stopScan])
            } catch let error {
                if case let error as DeviceError = error {
                    let bstError = Observable<Mutation>.just(.deviceError(BSTError.device(error)))
                    self.device.receiveError(error: error)
                    return Observable.concat([stopScan, bstError])
                } else {
                    return Observable.concat([stopScan])
                }
            }
            
        case let .pairingDevice(peripheral):
            let paring = Observable<Mutation>.just(.paringDevice(true))
            let paringError = Observable<Mutation>.just(.paringDevice(false))
            
            let contentMsg = Observable<Mutation>.just(.contentMsg(ContentMessage.connectedDevice))
            
            do {
                let setActiveDevice = try self.service.connect(scannedPeripheral: peripheral).map { Mutation.setActiveDevice($0) }
                let setCharacteristic = try self.service.setChracteristic(scannedPeripheral: peripheral).map { Mutation.setCharacteristic($0) }
                return Observable.concat([paring, setActiveDevice, setCharacteristic, contentMsg])
            } catch let error {
                if case let error as DeviceError = error {
                    let bstError = Observable<Mutation>.just(.deviceError(BSTError.device(error)))
                    self.device.receiveError(error: error)
                    return Observable.concat([paringError, bstError])
                } else {
                    return Observable.concat([paringError])
                }
            }
            
        case .blinkLight :
            return Observable.just(Mutation.blinkLight(true))
        case .writeCode :
            return Observable.just(Mutation.setWriteCode(""))
        case .registerDevice :
            let device = self.currentState.activePeripheral
            let isRegister = self.service.saveDevice(device: device).map { Mutation.registerDevice($0) }
            
            if let loadDevice = self.service.loadDevice() {
                let registeredDevice = Observable.just(loadDevice).map { Mutation.loadRegisterDevice($0) }
                self.device.registeredDeviceObserver.onNext(loadDevice)
                return Observable.concat([isRegister, registeredDevice])
            }
            return Observable.concat([isRegister])
        }
    }

// swiftlint:disable:next cyclomatic_complexity
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
        case let .loadRegisterDevice(device):
            newState.registeredDevice = device
        case .deviceError(let error):
            newState.deviceError = error
        case .contentMsg(let msg):
            newState.contentMsg = msg
        }
        return newState
    }
}

enum ContentMessage {
    
    typealias RDevice = R.string.device
    typealias RCommon = R.string.common
    
    case notScanning
    case connectedDevice
    case showUser(String)
    
    var content: String {
        switch self {
        case .notScanning:
            return RDevice.btContentScan()
        case .connectedDevice:
            return RDevice.btContentConnected()
        case .showUser(let user):
            return RDevice.btContentUserInfo(user)
        }
    }
}
