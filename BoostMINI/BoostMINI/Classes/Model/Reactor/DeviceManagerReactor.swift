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

final class DeviceManagerReactor : Reactor {
    
    enum Action {
        case scanDevice
        case pairingDevice
        case blinkLight
        case writeCode
        case registerDevice
    }
    
    enum Mutation {
        case scanDevice(Bool)
        case setDiscoverDevice(CBPeripheral)
        case paringDevice(Bool)
        case setActiveDevice(CBPeripheral)
        case setWriteCode(String)
        case blinkLight(Bool)
        case registerDevice(Bool)
    }
    
    struct State {
        var isScanDevice : Bool = false
        var isParingDevice : Bool = false
        var discoverPeripheral : CBPeripheral?
        var activePeripheral : CBPeripheral?
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
//        switch action {
//        case <#pattern#>:
//            <#code#>
//        default:
//            <#code#>
//        }
        
        return Observable.just(Mutation.scanDevice(false))
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
//        switch mutation {
//        case <#pattern#>:
//            <#code#>
//        default:
//            <#code#>
//        }
        return state
    }
}
