//
//  FakeServices.swift
//  gHubChatTests
//
//  Created by Jahid Hassan on 10/2/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import XCTest
@testable import gHubChat

class FakeServices: ServiceProtocol {
    enum URLFlag: Int {
        case forbibben=403, noData=404, error, data=200
    }
    
    enum FetchURL {
        case forbibben, noData, error, data
        
        var url: URL {
            switch self {
            case .forbibben:
                return URL(string: "https://api.github.com/users?since=\(URLFlag.forbibben)")!
            case .noData:
                return URL(string: "https://api.github.com/users?since=\(URLFlag.noData)")!
            case .error:
                return URL(string: "https://api.github.com/users?since=\(URLFlag.error)")!
            case .data:
                return URL(string: "https://api.github.com/users?since=\(URLFlag.data)")!
            }
        }
    }
    
    let fakeData = """
        [
            {
                "login": "x",
                "id": 1,
                "avatar_url": "https://google.com/",
            }
        ]
    """
    
    func get(url: URL, callback: @escaping (Result<Data, NetworkError>) -> Void) {
        switch url {
        case FetchURL.forbibben.url:
            callback(.failure(.forbidden))
        case FetchURL.noData.url:
            callback(.failure(.noData))
        case FetchURL.data.url:
            callback(.success(fakeData.data(using: .utf8)!))
        default:
            callback(.failure(.error("Custom error")))
        }
    }
}
