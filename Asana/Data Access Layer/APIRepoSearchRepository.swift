//
//  APIRepoSearchRepository.swift
//  Asana
//
//  Created by Ilya Puchka on 21/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import Foundation

extension URLRequest {
    static func repoSearchRequest(query: RepoSearchQuery) -> URLRequest {
        return request(URLComponents().with {
            $0.path = "/search/repositories"
            $0.queryItems = [
                URLQueryItem(name: "q", value: query.query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)),
                URLQueryItem(name: "sort", value: query.sort?.rawValue),
                URLQueryItem(name: "order", value: query.order.rawValue)
            ].filter({ $0.value != nil })
        })
    }
}

class APIRepoSearchRepository: RepoSearchRepository {
    let networkSession: NetworkSession
    
    init(networkSession: NetworkSession) {
        self.networkSession = networkSession
    }
    
    func getRepositories(query: RepoSearchQuery, completion: @escaping ([Repo]?, Error?) -> Void) {
        networkSession.request(.repoSearchRequest(query: query)) { (repos, _, _, error) in
            completion(repos, error)
        }
    }
}
