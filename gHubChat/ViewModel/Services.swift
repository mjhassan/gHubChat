//
//  Services.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/21/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case unknown
}

class Services: ServiceProtocol {
    typealias Callback = (Result<Data, Error>) -> Void
    
    func get( url: URL, completion: @escaping Callback ) {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NetworkError.unknown))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
