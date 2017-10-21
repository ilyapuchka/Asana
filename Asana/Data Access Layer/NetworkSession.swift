//
//  NetworkSession.swift
//  Asana
//
//  Created by Ilya Puchka on 21/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import Foundation

protocol NetworkSession {
    func request<T: Codable>(_ request: URLRequest, completion: @escaping (T?, Data?, HTTPURLResponse?, Error?) -> Void)
}

extension URLSession: NetworkSession {
    func request<T: Codable>(_ request: URLRequest, completion: @escaping (T?, Data?, HTTPURLResponse?, Error?) -> Void) {
        dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(decoded, data, response as? HTTPURLResponse, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, data, response as? HTTPURLResponse, error)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, data, response as? HTTPURLResponse, error)
                }
            }
            }.resume()
    }
}
