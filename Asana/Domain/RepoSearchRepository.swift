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

protocol RepoSearchRepository {
    func getRepositories(query: RepoSearchQuery, completion: @escaping ([Repo]?, Error?) -> Void)
}
