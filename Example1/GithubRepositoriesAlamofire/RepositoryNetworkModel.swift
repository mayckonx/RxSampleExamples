//
//  RepositoryNetworkModel.swift
//  Example1
//
//  Created by Mayckon Barbosa da Silva on 8/30/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import Foundation
import RxAlamofire
import ObjectMapper
import RxSwift
import RxCocoa

struct RepositoryNetworkModel {
    
    lazy var rx_repositories: Driver<[RepositoryGit]> = self.fetchRepositories()
    private var repositoryName: Observable<String>
    private let schedulerBackground: ConcurrentDispatchQueueScheduler
    
    init(with nameObservable: Observable<String>) {
        self.repositoryName = nameObservable
        self.schedulerBackground = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: .background, relativePriority: 1))
    }
    
    private func fetchRepositories() -> Driver<[RepositoryGit]>{
        return repositoryName
        .subscribeOn(MainScheduler.instance)
        .do(onNext: { text in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        })
        .observeOn(schedulerBackground)
        .flatMapLatest { text in
            return RxAlamofire
                .requestJSON(.get, URL(string: "https://api.github.com/users/\(text)/repos")!)
                .debug()
                .catchError { error in
                    return Observable.never()
                }
        }
        .observeOn(schedulerBackground)
        .map({ (response, json) -> [RepositoryGit] in
            if let repos = Mapper<RepositoryGit>().mapArray(JSONObject: json) {
                return repos
            }
            else {
                return []
            }
        })
        .observeOn(MainScheduler.instance)
        .do(onNext: { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
        .asDriver(onErrorJustReturn: [])
    }
}
