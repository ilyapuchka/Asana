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
    
    func testThatItCanGetSearchResults() throws {
        let fileSession = FileNetworkSession()
        
        let query = RepoSearchQuery(query: "")
        let request = URLRequest.repoSearchRequest(query: query)
        
        let nextPage = "https://api.github.com/resource?page=2"
        let lastPage = "https://api.github.com/resource?page=5"
        let response = HTTPURLResponse(url: request.url!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: [
                                        "Link": "<\(nextPage)>; rel=\"next\", <\(lastPage)>; rel=\"last\""
            ])!
        
        let data = try Data(resource: R.file.repoJson)
        let repo = try JSONDecoder().decode(Repo.self, from: data)
        
        fileSession.responses[request] = Repos(items: [repo])
        fileSession.httpResponse[request] = response
        fileSession.data[request] = data
        
        let sut = APIRepoSearchRepository(networkSession: fileSession)
        
        let expectCompleted = expectation(description: "Completion handler called")
        
        sut.getRepositories(query: query) { (results) in
            
            XCTAssertNil(results.error)
            XCTAssertEqual(results.repos?.count, 1)
            XCTAssertEqual(results.pages?[.next], nextPage)
            XCTAssertEqual(results.pages?[.last], lastPage)
            
            expectCompleted.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

}
