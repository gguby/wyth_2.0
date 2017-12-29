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

final class DeviceManagerReactor : Reactor {
    
    enum Action {
    }
    
    enum Mutation {
	case event
    }
    
    struct State {
    }
    
    let initialState = State()
    
//    fileprivate let service : service
    
//    init(service : service) {
//        self.service = service
//    }
    
    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//        case <#pattern#>:
//            <#code#>
//        default:
//            <#code#>
//        }
        return Observable.just(Mutation.event)
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