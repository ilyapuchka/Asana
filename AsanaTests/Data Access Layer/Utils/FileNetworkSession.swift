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
    var data: [URLRequest: Data] = [:]
    var httpResponse: [URLRequest: HTTPURLResponse] = [:]
    var errors: [URLRequest: Error] = [:]
    
    func request<T: Decodable>(_ request: URLRequest, completion: @escaping (T?, Data?, HTTPURLResponse?, Error?) -> Void) {
        DispatchQueue.main.async {
            completion(self.responses[request] as? T, self.data[request], self.httpResponse[request], self.errors[request])
        }
    }
}
