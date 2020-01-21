//
//  InitialViewModelProtocol.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/21/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

protocol InitialViewModelProtocol: ObservableObject {
    var isEmpty: Bool { get }
    var lastUserId: Int { get }
    var filter: String { get set }
    var list: [User] { get }
    
    func loadData(_ startId: Int?)
}

extension InitialViewModelProtocol {
    func loadData(_ startId: Int? = 0) { loadData(startId) }
}
