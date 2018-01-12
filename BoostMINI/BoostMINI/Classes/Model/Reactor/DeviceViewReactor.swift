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
        case connectAll
    }
    
    enum Mutation {
        case scanDevice(Bool)
        case setDiscoverDevice(ScannedPeripheral)
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
        var discoverPeripherals : [ScannedPeripheral] = []
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
            logVerbose(device.name + device.uuid.uuidString)
        }
    }
    
    func mutate(action: DeviceViewReactor.Action) -> Observable<DeviceViewReactor.Mutation> {
        switch action {
        case .connectAll:
                let scanDevice = self.service.scan().map(Mutation.scanDevice)
                let connect = self.service.connect()
                    .map { Mutation.setActiveDevice($0) }
                    .catchErrorJustReturn(Mutation.paringDevice(false))
            
            return .concat([scanDevice, connect])
        }
    }
    
// swiftlint:disable:next cyclomatic_complexity
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .scanDevice(isScan):
            newState.isScanDevice = isScan
            newState.contentMsg = isScan ? ContentMessage.findDevice : ContentMessage.notScanning
            newState.deviceError = isScan ? nil : BSTError.device(DeviceError.scanFailed)
        case let .setDiscoverDevice(scanDevice):
            logVerbose(scanDevice.advertisementData)
        case let .paringDevice(paring):
            newState.isParingDevice = paring
            newState.deviceError = paring ? nil : BSTError.device(DeviceError.paringFailed)
        case let .setActiveDevice(activePeripheral):
            newState.activePeripheral = activePeripheral
            newState.isParingDevice = true
            newState.contentMsg = ContentMessage.connectedDevice
            newState.deviceError = nil
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
    case findDevice
    case connectedDevice
    case showUser(String)
    
    var content: String {
        switch self {
        case .notScanning:
            return RDevice.btContentScan()
        case .findDevice:
            return RDevice.btContentFindDevice()
        case .connectedDevice:
            return RDevice.btContentConnected()
        case .showUser(let user):
            return RDevice.btContentUserInfo(user)
        }
    }
}
