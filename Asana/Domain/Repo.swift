//
//  Repo.swift
//  Asana
//
//  Created by Ilya Puchka on 21/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import Foundation

struct Repo: Decodable {
    
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let forksCount: Int
    
    struct Owner: Codable {
        
        let id: Int
        let avatarURL: URL
        let login: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case avatarURL = "avatar_url"
            case login
        }
    }

    let owner: Owner

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case owner
        case description
        case forksCount = "forks_count"
    }
}
