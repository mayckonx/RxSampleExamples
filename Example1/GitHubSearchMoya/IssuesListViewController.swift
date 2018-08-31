//
//  IssuesListViewController.swift
//  Example1
//
//  Created by Mayckon Barbosa da Silva on 8/29/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class IssuesListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    var provider: MoyaProvider<GitHub>!
    var issueTrackerModel: IssueTrackerModel!
    
    var latestRepositoryName: Observable<String> {
        return searchBar
        .rx.text
        .orEmpty
        .filter { $0.count > 0 }
        .debounce(0.5, scheduler: MainScheduler.instance)
        .distinctUntilChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRx()
    }
    
    func setupRx() {
        
        provider = MoyaProvider<GitHub>(plugins: [NetworkLoggerPlugin()])
        issueTrackerModel = IssueTrackerModel(provider: provider, repositoryName: latestRepositoryName)
        
        issueTrackerModel
        .trackIssues()
        .bind(to: tableView.rx.items) { tableView, row, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "issueCell", for: IndexPath(row: row, section: 0))
            cell.textLabel?.text = item.title
            
            return cell
        }
        .disposed(by: disposeBag)
        
        tableView
        .rx.itemSelected
        .subscribe(onNext: { [unowned self] indexPath in
            if self.searchBar.isFirstResponder == true {
                self.view.endEditing(true)
            }
        })
        .disposed(by: disposeBag)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
