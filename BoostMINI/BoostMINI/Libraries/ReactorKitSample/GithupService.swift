//
//  GithupService.swift
//  reactorKitSample
//
//  Created by wsjung on 2017. 12. 14..
//  Copyright © 2017년 wsjung. All rights reserved.
//

import Foundation
import Moya
import Mapper
import RxSwift
import RxOptional
import Moya_ModelMapper

struct List: Mappable {
    
    let totalCount : Int
    let result : Bool
    let items : [Repository]
    
    init(map: Mapper) throws {
        try totalCount = map.from("total_count")
        result = map.optionalFrom("incomplete_results") ?? false
        items = map.optionalFrom("items") ?? []
    }
}

struct Repository: Mappable {
    let identifier: Int
    let language: String
    let name: String
    let fullName: String
    
    init(map: Mapper) throws {
        try identifier = map.from("id")
        language = map.optionalFrom("language") ?? ""
        try name = map.from("name")
        try fullName = map.from("full_name")
    }
}

struct Issue: Codable {
    var identifier: Int
    var number: Int
    var title: String
    var body: String

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case number = "number"
        case title = "title"
        case body = "body"
    }
}

struct GithubService {
    //plugins: [NetworkLoggerPlugin(verbose: true)]
    let provider = MoyaProvider<GitHub>()
    
    func search(query: String?, page: Int) -> Observable<List> {
        return self.provider.rx
            .request(GitHub.search(query: query, page: page))
            .debug()
            .map(to: List.self)
            .asObservable()
    }
    
//    func trackIssues(query:String) -> Observable<[Issue]> {
//        return  self.findRepository(name: query)
//            .flatMapLatest({
//                repository -> Observable<[Issue]?> in
//                guard let repository = repository else { return Observable.just(nil)}
//                return self.findIssues(repository: repository)
//            })
//        .replaceNilWith([])
//    }
    
    internal func findIssues(repository: Repository) -> Observable<[Issue]> {
        return self.provider.rx
            .request(GitHub.issues(repositoryFullName: repository.fullName))
            .debug()
            .map([Issue].self)
            .asObservable()
    }
    
    internal func findRepository(name: String) -> Observable<Repository?> {
        return self.provider.rx
            .request(GitHub.repo(fullName: name))
            .debug()
            .mapOptional(to: Repository.self)
            .asObservable()
    }
    
  
}
