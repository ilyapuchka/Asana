//
//  RepoTests.swift
//  AsanaTests
//
//  Created by Ilya Puchka on 21/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import XCTest
@testable import Asana
import Rswift

class RepoTests: XCTestCase {
    
    func testRepoIsCodable() throws {
        let data = try Data(resource: R.file.repoJson)
        let repo = try JSONDecoder().decode(Repo.self, from: data)
        
        XCTAssertEqual(repo.id, 3081286)
        XCTAssertEqual(repo.name, "Tetris")
        XCTAssertEqual(repo.fullName, "dtrupenn/Tetris")
        XCTAssertEqual(repo.forksCount, 0)
        XCTAssertEqual(repo.owner.id, 872147)
        XCTAssertEqual(repo.owner.login, "dtrupenn")
        XCTAssertEqual(repo.owner.avatarURL, URL(string: "https://secure.gravatar.com/avatar/e7956084e75f239de85d3a31bc172ace?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png")!)
    }
    
}
