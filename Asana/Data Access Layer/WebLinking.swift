//
//  WebLinking.swift
//  Asana
//
//  Created by Ilya Puchka on 21/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    
    var links: [String: URL] {
        if let linkHeader = allHeaderFields["Link"] as? String {
            let links = linkHeader.components(separatedBy: ",").flatMap({ (link) -> (String, URL)? in
                let components = link.components(separatedBy: ";")
                guard let linkComponent = components.first, let relationComponent = components.last else { return nil }
                
                guard let relation = relationComponent
                    .components(separatedBy: "=")
                    .last?
                    .trimmingPrefix("\"")
                    .trimmingSuffix("\"")
                    else { return nil }
                
                let url = linkComponent
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .trimmingPrefix("<")
                    .trimmingSuffix(">")
                
                if let baseURL = self.url, let relativeURL = URL(string: url, relativeTo: baseURL) {
                    return (relation, relativeURL)
                } else if let url = URL(string: url) {
                    return (relation, url)
                } else {
                    return nil
                }
            })
            return .init(links, uniquingKeysWith: { $1 })
        }
        
        return [:]
    }
}

extension String {
    func trimmingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(characters.suffix(characters.count - prefix.characters.count))
    }
    
    func trimmingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(characters.prefix(characters.count - suffix.characters.count))
    }

}
