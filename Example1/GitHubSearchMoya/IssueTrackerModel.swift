//
//  IssueTrackerModel.swift
//  Example1
//
//  Created by Mayckon Barbosa da Silva on 8/29/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import Foundation
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional
import RxSwift

struct IssueTrackerModel {
    let provider: MoyaProvider<GitHub>
    let repositoryName: Observable<String>
    
    func trackIssues() -> Observable<[Issue]> {
        return repositoryName
        .observeOn(MainScheduler.instance)
        .flatMapLatest { name -> Observable<Repository?> in
            print("name: \(name)")
            return self.findRepository(name: name)
        }
        .flatMapLatest { repository -> Observable<[Issue]?> in
            guard let repository = repository else { return Observable.just(nil) }
            print("Repository:\(repository.fullName)")
            return self.findIssues(repository: repository)
        }
        .replaceNilWith([])
    }
    
    internal func findIssues(repository: Repository) -> Observable<[Issue]?> {
        return self.provider.rx
        .request(GitHub.issues(repositoryFullName: repository.fullName))
        .debug()
        .mapOptional(to: [Issue].self)
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
