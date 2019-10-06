//
//  ServiceProtocol.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/21/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

protocol ServiceProtocol {
    func get( url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}
