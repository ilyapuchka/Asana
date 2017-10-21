//
//  RepoSearchRepository.swift
//  Asana
//
//  Created by Ilya Puchka on 21/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import Foundation

struct RepoSearchQuery {
    let query: String
    
    enum Sorting: String {
        case stars, forks, updated
    }
    
    let sort: Sorting?
    
    enum Order: String {
        case asc, desc
    }
    
    let order: Order
    
    init(query: String, sort: Sorting? = nil, order: Order = .desc) {
        self.query = query
        self.sort = sort
        self.order = order
    }
    
}

struct RepoSearchResult {
    let response: HTTPURLResponse?
    let repos: [Repo]?
    let error: Error?
    
    enum Pagination: String {
        case next, last
    }

    let pages: [Pagination: URL]

    init(response: HTTPURLResponse?, repos: [Repo]?, error: Error?) {
        self.response = response
        self.repos = repos
        self.error = error
        
        var _pages = [Pagination: URL]()
        self.response?.links.forEach({ (key, value) in
            if let pageKey = Pagination(rawValue: key) {
                _pages[pageKey] = value
            }
        })
        self.pages = _pages
    }

    var isLastPage: Bool? {
        guard let currentURL = response?.url else { return nil }
        guard let lastPage = pages[.last] else { return nil }
        return lastPage == currentURL
    }
}

protocol RepoSearchRepository {
    func getRepositories(query: RepoSearchQuery, completion: @escaping (RepoSearchResult) -> Void)
    func getRepositories(url: URL, completion: @escaping (RepoSearchResult) -> Void)
}
