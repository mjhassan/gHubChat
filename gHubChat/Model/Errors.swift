//
//  Errors.swift
//  gHubChat
//
//  Created by Jahid Hassan on 9/30/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

enum NetworkError: Error, Equatable {
    case error(String)
    case forbidden
    case noData
    
    var description: String {
        switch self {
        case let .error(_description):
            return _description
        default:
            return localizedDescription
        }
    }
}
