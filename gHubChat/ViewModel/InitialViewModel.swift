//
//  InitialViewModel.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/19/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

class InitialViewModel {
    private let URL_TEMP: String = "https://api.github.com/users?since="
    private var startId: Int = 0
    private var users: BehaviorRelay<[User]>  = BehaviorRelay(value: [])
    internal var list: BehaviorRelay<[User]>  = BehaviorRelay(value: [])
    internal var query: BehaviorRelay<String> = BehaviorRelay(value: "")
    internal var isLoading = PublishSubject<Bool>()
    
    public var userCount: Int {
        return list.value.count
    }
    
    public var lastUserId: Int {
        return user(at: userCount-1)?.id ?? startId
    }
    
    private let disposeBag = DisposeBag()
    
    init() {
        query
            .asObservable()
            .subscribe(onNext: { [weak self] txt in
                self?.filterUser(txt)
            }).disposed(by: disposeBag)
    }
    
    func loadData(_ startId: Int? = 0) {
        if let _id = startId {
            self.startId = _id
        }
        
        guard let url = URL(string: URL_TEMP.appending("\(self.startId)")) else {
            return
        }
        
        isLoading.onNext(true)
        Services().get(url: url) { [weak self] result in
            guard let _ws = self else { return }
            
            _ws.isLoading.onNext(false)
            
            switch result {
                case .success(let data):
                    let _users = _ws.decode(data: data)
                    
                    _ws.users.accept(_ws.users.value + _users)
                    _ws.query.accept("")
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func user(at index: Int) -> User? {
        return (index >= 0 && index < userCount) ? list.value[index]:nil
    }
    
    private func decode(data: Data) -> [User] {
        do {
            let models = try JSONDecoder().decode([User].self, from: data)
            return models
        } catch _ {
            return []
        }
    }
    
    private func filterUser(_ txt: String = "") {
        let result = txt.isEmpty
            ? users.value
            : users.value.filter { $0.login.contains(txt) }
        
        list.accept(result)
    }
}
