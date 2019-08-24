//
//  InitialViewModelProtocol.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/21/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

protocol InitialViewModelProtocol {
    var userCount: Int { get }
    var lastUserId: Int { get }
    var filter: String { get set }
    
    init(bind delegate: InitialViewDelegate?)
    
    func loadData(_ startId: Int?)
    func user(at index: Int) -> User?
}

extension InitialViewModelProtocol {
    func loadData(_ startId: Int? = 0) { loadData(startId) }
}
