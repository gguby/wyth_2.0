//
//  ViewControllerReactor.swift
//  reactorKitSample
//
//  Created by wsjung on 2017. 12. 15..
//  Copyright © 2017년 wsjung. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class ViewControllerReactor : Reactor {
    
    enum Action {
        case updateQuery(String?)
        case loadNextPage
    }
    
    enum Mutation {
        case setQuery(String?)
        case setRepos([Repository], nextPage: Int?)
        case appendRepos([Repository], nextPage: Int?)
        case setLoadingNextPage(Bool)
    }
    
    struct State {
        var query: String?
        var repos: [Repository] = []
        var nextPage: Int?
        var isLoadingNextPage: Bool = false
    }
    
    let initialState = State()
    
    fileprivate let githubService : GithubService
    
    init(service : GithubService) {
        self.githubService = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateQuery(query) :            
            return Observable.concat([
                Observable.just(Mutation.setQuery(query)),
                
                self.githubService.search(query: query, page: 1)
                    .takeUntil(self.action.filter(isUpdateQueryAction))
                    .map {
                        list in
                        Mutation.setRepos(list.items, nextPage: 2)
                },
            ])
            
        case .loadNextPage :
            guard !self.currentState.isLoadingNextPage else { return Observable.empty() } // prevent from multiple requests
            guard let page = self.currentState.nextPage else { return Observable.empty() }
            return Observable.concat([
                Observable.just(Mutation.setLoadingNextPage(true)),
                
                self.githubService.search(query: self.currentState.query, page: page)
                    .takeUntil(self.action.filter(isUpdateQueryAction))
                    .map {
                        list in
                        Mutation.setRepos(list.items, nextPage: page + 1)
                },
                
                Observable.just(Mutation.setLoadingNextPage(false)),
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setQuery(query):
            var newState = state
            newState.query = query
            return newState
            
        case let .setRepos(repos, nextPage):
            var newState = state
            newState.repos = repos
            newState.nextPage = nextPage
            return newState
            
        case let .appendRepos(repos, nextPage):
            var newState = state
            newState.repos.append(contentsOf: repos)
            newState.nextPage = nextPage
            return newState
            
        case let .setLoadingNextPage(isLoadingNextPage):
            var newState = state
            newState.isLoadingNextPage = isLoadingNextPage
            return newState
        }
    }
    
    private func isUpdateQueryAction(_ action: Action) -> Bool {
        if case .updateQuery = action {
            return true
        } else {
            return false
        }
    }
}
