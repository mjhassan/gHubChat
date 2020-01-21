//
//  InitialViewModel.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/19/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
import Combine

class InitialViewModel: InitialViewModelProtocol {
//    private let delegate: InitialViewDelegate?
    private let URL_TEMP: String = "https://api.github.com/users?since="
    private var startId: Int = 0
    private var users: [User] = []
    var list: [User] = [] {
       didSet {
           didChange.send(())
       }
   }
    
    var isEmpty: Bool {
        return users.isEmpty
    }
    
    public var lastUserId: Int {
        return list.last?.id ?? startId
    }
    
    public var filter: String = "" {
        didSet {
            filterUser()
//            delegate?.didUpdatedData()
        }
    }
    
    var didChange = PassthroughSubject<Void, Never>()
    
    func loadData(_ startId: Int? = 0) {
        users.append(contentsOf: userData)
        filterUser()
        
        return
        
        if let _id = startId {
            self.startId = _id
        }
        
        guard let url = URL(string: URL_TEMP.appending("\(self.startId)")) else {
            return
        }
        
//        delegate?.willStartNetworkActivity()
        
        Services().get(url: url) { [weak self] result in
            switch result {
            case .success(let data):
                if let _users = self?.decode(data: data) {
                    self?.users.append(contentsOf: _users)
                    self?.filterUser()
                }
            case .failure(let err):
//                self?.delegate?.didFailedWithError(err)
                print(err)
            }
        }
    }
    
    private func decode(data: Data) -> [User] {
        do {
            return try JSONDecoder().decode([User].self, from: data)
            
//            self.delegate?.didUpdatedData()
        } catch let err {
//            self.delegate?.didFailedWithError(err)
        }
        
        return []
    }
    
    private func filterUser() {
        list.removeAll()
        list = filter.isEmpty ? users:users.filter { $0.login.contains(filter) }
    }
}
