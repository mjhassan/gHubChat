//
//  Services.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/21/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

class Services: ServiceProtocol {
    typealias callback = (Result<Data, NetworkError>) -> Void
    
    func get( url: URL, callback: @escaping callback ) {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                callback(.failure(.error(error?.localizedDescription ?? "Unknown error occured")))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 403 {
                callback(.failure(.forbidden))
                return
            }
            
            guard let data = data else {
                callback(.failure(.noData))
                return
            }
            
            callback(.success(data))
        }.resume()
    }
}
