//
//  InitialViewModel.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/19/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

class InitialViewModel: InitialViewModelProtocol {
    private let delegate: InitialViewDelegate?
    private let URL_TEMP: String = "https://api.github.com/users?since="
    private var startId: Int = 0
    private var users: [User] = []
    private var list: [User] = []
    private let service: ServiceProtocol!
    
    public var userCount: Int {
        return list.count
    }
    
    public var lastUserId: Int {
        return user(at: userCount-1)?.id ?? startId
    }
    
    public var filter: String = "" {
        didSet {
            filterUser()
            delegate?.didUpdatedData()
        }
    }
    
    required init(bind delegate: InitialViewDelegate?, service: ServiceProtocol) {
        self.delegate = delegate
        self.service = service
    }
    
    func loadData(_ startId: Int? = 0) {
        if let _id = startId {
            self.startId = _id
        }
        
        guard let url = URL(string: URL_TEMP.appending("\(self.startId)")) else {
            return
        }
        
        delegate?.willStartNetworkActivity()
        
        service.get(url: url) { [weak self] result in
            switch result {
            case .success(let data):
                self?.decode(data: data)
            case .failure(let err):
                self?.delegate?.didFailedWithError(err)
            }
        }
    }
    
    func user(at index: Int) -> User? {
        return (index >= 0 && index < userCount) ? list[index]:nil
    }
    
    private func decode(data: Data) {
        do {
            let models = try JSONDecoder().decode([User].self, from: data)
            self.users.append(contentsOf:models)
            
            filterUser()
            self.delegate?.didUpdatedData()
        } catch let err {
            self.delegate?.didFailedWithError(err)
        }
    }
    
    private func filterUser() {
        list.removeAll()
        list = filter.isEmpty ? users:users.filter { $0.login.contains(filter) }
    }
}
