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
    
    enum ReactorViewType {
        case Login
        case Management
    }
    
    typealias RDevice = R.string.device
    typealias RCommon = R.string.common
    
    enum Action {
        case connectAll
        case manageMentInit
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
        case managementViewInit
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
        var titleMsg : String = RDevice.btTitleLbl()
        var isManageMentView : Bool = false
    }
    
    let initialState = State()
    
    fileprivate let service : BTDeviceService
    
    fileprivate let device = BSTFacade.device
    
    var viewType = ReactorViewType.Login
    
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
            return .concat([scanDevice, paring, connectedDevice, register])
        case .manageMentInit:
            let localDevice = self.service.loadDevice()
            let deviceLoad = Observable.just(Mutation.loadRegisterDevice(localDevice))
            let initView = Observable.just(Mutation.managementViewInit)
            return .concat([deviceLoad, initView])
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
            newState.titleMsg = paring ? RDevice.btTitleConnectLbl() : RDevice.btTitleLbl() 
        case let .setActiveDevice(activePeripheral):
            newState.activePeripheral = activePeripheral
            newState.contentMsg = ContentMessage.connectedDevice
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
            
            if let device = device {
                self.device.registeredDeviceObserver.onNext(device)
            }
            
        case .deviceError(let error):
            newState.deviceError = error
        case .contentMsg(let msg):
            newState.contentMsg = msg
        case .managementViewInit:
            newState.titleMsg = RDevice.btTitleManage()
            if let device = self.currentState.registeredDevice {
                newState.contentMsg = ContentMessage.showUser(device.name)
                newState.isRegister = true
            } else {
                newState.contentMsg = ContentMessage.notRegistered
                newState.isRegister = false
            }
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
