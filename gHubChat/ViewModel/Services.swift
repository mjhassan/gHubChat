//
//  Services.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/21/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

class Services: ServiceProtocol {
    typealias callback = (_ data: Data?, _ error: Error?) -> Void
    
    func get( url: URL, callback: @escaping callback ) {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            callback(data, error)
            }.resume()
    }
}
