//
//  RepositoriesListController.swift
//  Asana
//
//  Created by Ilya Puchka on 21/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import UIKit

class RepositoriesListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            registerReusableViews()
            tableView.estimatedRowHeight = 50
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }

    var dataProvider: RepositoriesListDataProvider?
    var model: RepositoriesListViewModel = RepositoriesListViewModel() {
        didSet {
            if model.isLoading {
                loadingView?.startAnimating()
                tableView?.isHidden = true
            } else {
                loadingView?.stopAnimating()
                tableView?.isHidden = false
                tableView?.reloadData()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        model.isLoading = true
        dataProvider?.getRepositories(query: RepoSearchQuery(query: "Tetris"), completion: { [weak self] (repos, error) in
            self?.model = repos ?? RepositoriesListViewModel()
        })
    }

}

extension RepositoriesListController: ListView {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRow(at: indexPath)
    }

}

struct RepositoriesListViewModel: ListViewModel {
    typealias Item = RepositoriesListCellViewModel
    typealias Cell = RepositoriesListCell

    let repos: [RepositoriesListCellViewModel]
    let pages: RepoSearchResult.Pages?
    var isLoading: Bool = false
    
    init(repos: RepoSearchResult? = nil) {
        self.repos = repos?.repos?.map(RepositoriesListCellViewModel.init(repo:)) ?? []
        self.pages = repos?.pages
    }
    
    func numberOfRows() -> Int {
        return repos.count
    }
    
    func item(at index: Int) -> Item? {
        guard index < repos.count else { return nil }
        return repos[index]
    }

}

class RepositoriesListDataProvider {
    
    let searchService: RepoSearchService
    private var result: RepoSearchResult?
    
    init(searchService: RepoSearchService) {
        self.searchService = searchService
    }
    
    func getRepositories(query: RepoSearchQuery, completion: @escaping (RepositoriesListViewModel?, Error?) -> Void) {
        searchService.getRepositories(query: query) { (result) in
            guard result.error == nil else {
                completion(nil, result.error)
                return
            }
            
            completion(RepositoriesListViewModel(repos: result), nil)
        }
    }
    
    func getRepositories(completion: @escaping (RepositoriesListViewModel?, Error?) -> Void) {
        guard let result = result else {
            DispatchQueue.main.async {
                completion(nil, nil)
            }
            return
        }
        searchService.getMoreRepositories(result: result) { moreResults in
            guard result.error == nil else {
                completion(nil, result.error)
                return
            }
            
            completion(RepositoriesListViewModel(repos: result + moreResults), nil)
        }
    }
    
}
