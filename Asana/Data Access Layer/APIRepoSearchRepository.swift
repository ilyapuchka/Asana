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
    
    func getRepositories(query: RepoSearchQuery, completion: @escaping (RepoSearchResult) -> Void) {
        networkSession.request(.repoSearchRequest(query: query)) { (repos, _, response, error) in
            completion(RepoSearchResult(response: response, repos: repos, error: error))
        }
    }
    
    func getRepositories(pageHandle: RepoSearchResult.Pagination.Handle, completion: @escaping (RepoSearchResult) -> Void) {
        guard let url = URL(string: pageHandle) else {
            DispatchQueue.main.async {
                let error = URLError(URLError.badURL, userInfo: [
                    NSURLErrorFailingURLStringErrorKey: pageHandle
                    ])
                completion(RepoSearchResult(repos: nil, pages: nil, error: error))
            }
            return
        }
        networkSession.request(.init(url: url)) { (repos, _, response, error) in
            completion(RepoSearchResult(response: response, repos: repos, error: error))
        }
    }

}

extension RepoSearchResult {
    
    init(response: HTTPURLResponse?, repos: [Repo]?, error: Error?) {
        self.repos = repos
        self.error = error
        
        var _pages = [Pagination: String]()
        response?.links.forEach({ (key, value) in
            if let pageKey = Pagination(rawValue: key) {
                _pages[pageKey] = value.absoluteString
            }
        })
        self.pages = _pages
    }
    
}
