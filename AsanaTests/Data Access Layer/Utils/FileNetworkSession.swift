//
//  FileNetworkSession.swift
//  AsanaTests
//
//  Created by Ilya Puchka on 21/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import Foundation
@testable import Asana

class FileNetworkSession: NetworkSession {
    var responses: [URLRequest: Any] = [:]
    var errors: [URLRequest: Error] = [:]
    
    func request<T: Codable>(_ request: URLRequest, completion: @escaping (T?, Data?, HTTPURLResponse?, Error?) -> Void) {
        DispatchQueue.main.async {
            completion(self.responses[request] as? T, nil, nil, self.errors[request])
        }
    }
}
