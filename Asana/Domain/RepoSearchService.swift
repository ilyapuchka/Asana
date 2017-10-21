//
//  RepoSearchService.swift
//  Asana
//
//  Created by Ilya Puchka on 21/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import Foundation

class RepoSearchService {
    
    let repository: RepoSearchRepository
    
    init(repository: RepoSearchRepository) {
        self.repository = repository
    }
    
    func getRepositories(query: RepoSearchQuery, completion: @escaping (RepoSearchResult) -> Void) {
        repository.getRepositories(query: query, completion: completion)
    }
    
    func getMoreRepositories(result: RepoSearchResult, completion: @escaping (RepoSearchResult) -> Void) {
        guard let nextPage = result.pages?[.next] else {
            DispatchQueue.main.async {
                completion(RepoSearchResult(response: nil, repos: nil, error: nil))
            }
            return
        }
        repository.getRepositories(pageHandle: nextPage, completion: completion)
    }
}
