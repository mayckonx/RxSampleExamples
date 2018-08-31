//
//  RepositoriesViewController.swift
//  Example1
//
//  Created by Mayckon Barbosa da Silva on 8/30/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

class RepositoriesViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    var repositoryNetworkModel: RepositoryNetworkModel!
    
    var rx_searchBarText: Observable<String> {
        return searchBar
        .rx.text
        .orEmpty
        .filter { $0.count > 0 }
        .throttle(0.5, scheduler: MainScheduler.instance)
        .distinctUntilChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupRx()
    }
    
    func setupRx() {
        repositoryNetworkModel = RepositoryNetworkModel(with: rx_searchBarText)
        
        repositoryNetworkModel
        .rx_repositories
        .drive(tableView.rx.items) { tableView, index, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: IndexPath(row: index, section: 0))
            cell.textLabel?.text = item.name
            
            return cell
        }
        .disposed(by: disposeBag)
        
        repositoryNetworkModel
        .rx_repositories
        .drive(onNext: { repositories in
            if repositories.count == 0 {
                let alert = UIAlertController(title: ":(", message: "No repositories for this user.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                if self.navigationController?.visibleViewController?.isMember(of: UIAlertController.self) != true {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
        .disposed(by: disposeBag)
    }

}
