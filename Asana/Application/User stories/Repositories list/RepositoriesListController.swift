//
//  RepositoriesListController.swift
//  Asana
//
//  Created by Ilya Puchka on 21/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import UIKit

class RepositoriesListController: UIViewController, UITableViewDelegate, UITableViewDataSource, KeyboardObserver {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            registerReusableViews()
            tableView.estimatedRowHeight = 50
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.tableFooterView = UIView()
        }
    }

    var dataProvider: RepositoriesListDataProvider?
    var model: RepositoriesListViewModel = RepositoriesListViewModel() {
        didSet {
            if model.isLoading {
                loadingView?.startAnimating()
            } else {
                loadingView?.stopAnimating()
            }
            tableView?.reloadData()
        }
    }

    var keyboardObservers: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fix for invalid initial content offset on iPhone 5
        DispatchQueue.main.async {
            self.tableView.contentOffset = .zero
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startKeyboardObserving(in: tableView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopKeyboardObserving()
    }
}

extension RepositoriesListController: ListView {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !model.isLoading else {
            return 0
        }
        return numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRow(at: indexPath)
    }

}

extension RepositoriesListController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let query = searchBar.text else { return }
        model.isLoading = true
        dataProvider?.getRepositories(query: RepoSearchQuery(query: query), completion: { [weak self] (repos, error) in
            if let repos = repos {
                self?.model = repos
            }
        })
    }
    
}

struct RepositoriesListViewModel: ListViewModel {
    typealias Item = RepositoriesListCellViewModel
    typealias Cell = RepositoriesListCell

    let repos: [RepositoriesListCellViewModel]
    let pages: RepoSearchResult.Pages?
    var isLoading: Bool = false
    var isLoadingMore: Bool = false
    
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

    var isEmpty: Bool {
        return repos.isEmpty
    }
    
}

class RepositoriesListDataProvider {
    
    let searchService: RepoSearchService
    private var result: RepoSearchResult?
    
    init(searchService: RepoSearchService) {
        self.searchService = searchService
    }
    
    func getRepositories(query: RepoSearchQuery, completion: @escaping (RepositoriesListViewModel?, Error?) -> Void) {
        searchService.getRepositories(query: query) { [weak self] (result) in
            guard result.error == nil else {
                completion(nil, result.error)
                return
            }
            
            self?.result = result
            completion(RepositoriesListViewModel(repos: result), nil)
        }
    }
    
    func getMoreRepositories(completion: @escaping (RepositoriesListViewModel?, Error?) -> Void) {
        guard let result = result else {
            DispatchQueue.main.async {
                completion(nil, nil)
            }
            return
        }
        searchService.getMoreRepositories(result: result) { [weak self] moreResults in
            guard moreResults.error == nil else {
                completion(nil, moreResults.error)
                return
            }
            self?.result = result
            completion(RepositoriesListViewModel(repos: result + moreResults), moreResults.error)
        }
    }
    
}
