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
    let repos: [Repo]?
    let pages: [Pagination: Pagination.Handle]?
    let error: Error?

    enum Pagination: String {
        typealias Handle = String
        case next, last
    }
    
    init(repos: [Repo]?, pages: [Pagination: Pagination.Handle]?, error: Error?) {
        self.repos = repos
        self.pages = pages
        self.error = error
    }
}

protocol RepoSearchRepository {
    func getRepositories(query: RepoSearchQuery, completion: @escaping (RepoSearchResult) -> Void)
    func getRepositories(pageHandle: RepoSearchResult.Pagination.Handle, completion: @escaping (RepoSearchResult) -> Void)
}
