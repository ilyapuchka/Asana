//
//  APIRepoSearchRepositoryTests.swift
//  AsanaTests
//
//  Created by Ilya Puchka on 21/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import XCTest
@testable import Asana

class APIRepoSearchRepositoryTests: XCTestCase {

    func testRepoSearchRequestBuilder() {
        // given query with default parameters
        var request = URLRequest.repoSearchRequest(query: .init(query: "abc"))
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.path, "/search/repositories")
        XCTAssertEqual(request.url?.query, "q=abc&order=desc")
        
        // given query with sort and ascending order
        request = URLRequest.repoSearchRequest(query: .init(query: "abc", sort: .stars, order: .asc))
        XCTAssertEqual(request.url?.query, "q=abc&sort=stars&order=asc")
    }
    
    func testRepoSearchQueryParameters() {
        XCTAssertEqual(RepoSearchQuery.Sorting.stars.rawValue, "stars")
        XCTAssertEqual(RepoSearchQuery.Sorting.forks.rawValue, "forks")
        XCTAssertEqual(RepoSearchQuery.Sorting.updated.rawValue, "updated")
        XCTAssertEqual(RepoSearchQuery.Order.asc.rawValue, "asc")
        XCTAssertEqual(RepoSearchQuery.Order.desc.rawValue, "desc")
    }

}
