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
    
    typealias RDevice = R.string.device
    typealias RCommon = R.string.common
    
    enum Action {
        case connectAll
        case manageMentInit
        case clearDevice
        case errorScan
        case errorConnetion
    }
    
    enum Mutation {
        case scanDevice(Bool)
        case setDiscoverDevice(ScannedPeripheral)
        case paringDevice(Bool)
        case setActiveDevice(Peripheral)
        case setCharacteristic(Characteristic)
        case registerDevice(Bool)
        case loadRegisterDevice(BSTLocalDevice?)
        case deviceError(BSTError)
        case contentMsg(ContentMessage)
        case managementViewInit
        case clearDevice(Bool)
    }
    
    struct State {
        var isScanDevice : Bool = false
        var isParingDevice : Bool = false
        var discoverPeripherals : [ScannedPeripheral] = []
        var activePeripheral : Peripheral?
        var characteristic : Characteristic?
        var isRegister : Bool?
        var registeredDevice : BSTLocalDevice?
        var deviceError : BSTError?
        var contentMsg : ContentMessage = ContentMessage.notScanning
        var titleMsg : String = RDevice.btTitleLbl()
        var isManageMentView : Bool = false
    }
    
    let initialState = State()
    
    fileprivate let service : BTDeviceService
    
    fileprivate let device = BSTFacade.device
    
    var viewType = ReactorViewType.initialize
    
    init(service : BTDeviceService) {
        self.service = service
    }
    
    func mutate(action: DeviceViewReactor.Action) -> Observable<DeviceViewReactor.Mutation> {
        switch action {
        case .connectAll:
            let scanner = self.service.scanner()
            let scanDevice = self.service.scan(observable: scanner).map(Mutation.scanDevice)
            let paring = self.service.paring(observable: scanner).map(Mutation.paringDevice)
            let connect = self.service.connect(observable: scanner)
            let connectedDevice = connect.map { Mutation.setActiveDevice($0) }
            let register = self.service.register(observable: connect).map(Mutation.registerDevice)
            let characteristic = self.service.chrateristic(observable: connect).map { Mutation.setCharacteristic($0) }
            
            return .concat([scanDevice, paring, connectedDevice, characteristic, register])
        case .manageMentInit:
            let localDevice = self.service.loadDevice()
            let deviceLoad = Observable.just(Mutation.loadRegisterDevice(localDevice))
            let initView = Observable.just(Mutation.managementViewInit)
            return .concat([deviceLoad, initView])
        case .clearDevice:
            let isClear = self.service.clearDevice().map(Mutation.clearDevice)
            return isClear
        case .errorScan:
            let error = Observable.just(Mutation.deviceError(BSTError.device(DeviceError.scanFailed)))
            return error
        case .errorConnetion:
            let error = Observable.just(Mutation.deviceError(BSTError.device(DeviceError.paringFailed)))
            return error
        }
    }
    

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
            newState.titleMsg = paring ? RDevice.btTitleConnectLbl() : RDevice.btTitleLbl() 
        case let .setActiveDevice(activePeripheral):
            newState.activePeripheral = activePeripheral
            newState.contentMsg = ContentMessage.connectedDevice
        case let .setCharacteristic(characteristic):
            newState.characteristic = characteristic
//            self.service.triggerValueRead(for: characteristic)
//            self.service.writeValueForCharacteristic(hexadecimalString: "gg", characteristic: characteristic)
        case let .registerDevice(isRegister):
            newState.isRegister = isRegister
            let localDevice = self.service.loadDevice()
            self.device.registeredDeviceObserver.onNext(localDevice)
        case let .loadRegisterDevice(device):
            newState.registeredDevice = device
            
            if let device = device {
                self.device.registeredDeviceObserver.onNext(device)
                newState.isRegister = true
            } else {
                newState.isRegister = false
            }
            
        case .deviceError(let error):
            self.device.registeredDeviceObserver.onNext(nil)
            newState.deviceError = error
            newState.contentMsg = ContentMessage.notScanning
            newState.titleMsg = RDevice.btTitleLbl()
            newState.isRegister = false
            newState.isParingDevice = false
            newState.registeredDevice = nil
        case .contentMsg(let msg):
            newState.contentMsg = msg
        case .managementViewInit:
            newState.titleMsg = RDevice.btTitleManage()
            if let device = self.currentState.registeredDevice {
                newState.contentMsg = ContentMessage.showUser(device.userName)
            } else {
                newState.contentMsg = ContentMessage.notRegistered
            }
        case .clearDevice:
            self.device.registeredDeviceObserver.onNext(nil)
            newState.activePeripheral = nil
            newState.characteristic = nil
            newState.isRegister = false
            newState.registeredDevice = nil            
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
    case notRegistered
    
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
        case .notRegistered:
            return RDevice.btContentNotRegistered()
        }
    }
}

enum ReactorViewType {
    case initialize
    case Management
}
