//
//  NetworkSessionTests.swift
//  AsanaTests
//
//  Created by Ilya Puchka on 21/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import XCTest
@testable import Asana

class NetworkSessionTests: XCTestCase {
    
    func testDataTaskCompletionHandlerDecodesResponse() throws {
        // given repo data
        let data = try Data(resource: R.file.repoJson)
        let repo = try JSONDecoder().decode(Repo.self, from: data)
        
        // given response
        let response = HTTPURLResponse(url: URL(string: "https://api.github.com/search/repositories")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: [:])!

        let expectCompleted = expectation(description: "Completion handler called")
        let completionHandler = URLSession.shared.dataTaskCompletionHandler { (decoded: Repo?, data, response, error) in
            XCTAssertNotNil(response)
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            
            AssertNotDiff(repo, decoded)
            
            expectCompleted.fulfill()
        }

        completionHandler(data, response, nil)
        waitForExpectations(timeout: 1, handler: nil)
    }

}
