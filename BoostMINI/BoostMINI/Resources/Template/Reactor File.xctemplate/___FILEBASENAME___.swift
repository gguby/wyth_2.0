//___FILEHEADER___

//mkdir -p ~/Library/Developer/Xcode/Templates/Custom 해당 폴더에 .xctemplate 폴더 복사

import Foundation
import ReactorKit
import RxCocoa
import RxSwift

final class ___FILEBASENAME___ : Reactor {
    
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
