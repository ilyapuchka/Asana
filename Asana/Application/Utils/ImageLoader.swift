//
//  ImageLoader.swift
//  Asana
//
//  Created by Ilya Puchka on 21/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import UIKit

class ImageLoader {
    
    private var promises: [UUID: Promise<UIImage>] = [:]
    private var cache: [URL: UIImage] = [:]
    
    static let shared = ImageLoader()
    
    private init() {}
    
    func getImage(_ url: URL, completion: @escaping (UUID, UIImage?, Error?) -> Void) -> UUID {
        let uuid = UUID()
        let promise = Promise<UIImage>(work: { [unowned self] (completed, failed) in
            if let image = self.cache[url] {
                completed(image)
            } else {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    if let data = data, let image = UIImage(data: data) {
                        self.cache[url] = image
                        completed(image)
                    } else if let error = error {
                        failed(error)
                    }
                }.resume()
            }
        }).then(on: DispatchQueue.main, { [unowned self] (image) in
            guard self.promises[uuid] != nil else { return }
            completion(uuid, image, nil)
        }) { (error) in
            guard self.promises[uuid] != nil else { return }
            completion(uuid, nil, error)
        }
        promises[uuid] = promise
        return uuid
    }
    
    func cancelImageLoading(_ handle: UUID) {
        promises[handle] = nil
    }
}
