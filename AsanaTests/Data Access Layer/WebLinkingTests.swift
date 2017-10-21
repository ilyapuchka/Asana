//
//  WebLinkingTests.swift
//  AsanaTests
//
//  Created by Ilya Puchka on 21/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import XCTest
@testable import Asana

class WebLinkingTests: XCTestCase {
    
    func testThatItCanParseWebLinks() {
        let response = HTTPURLResponse(url: URL(string: "https://api.github.com/search/repositories")!,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: [
                            "Link": "<https://api.github.com/resource?page=2>; rel=\"next\", <https://api.github.com/resource?page=5>; rel=\"last\""
            ])!
        XCTAssertEqual(response.links["next"], URL(string: "https://api.github.com/resource?page=2")!)
        XCTAssertEqual(response.links["last"], URL(string: "https://api.github.com/resource?page=5")!)
    }
    
}
