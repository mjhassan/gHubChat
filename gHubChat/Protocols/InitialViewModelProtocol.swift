//
//  InitialViewModelProtocol.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/21/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol InitialViewModelProtocol {
    var list: BehaviorRelay<[User]> { get }
    var query: BehaviorRelay<String> { get }
    var isLoading:PublishSubject<Bool> { get }
    var error: PublishSubject<NetworkError> { get }
    var userCount: Int { get }
    var lastUserId: Int { get }
    var disposeBag: DisposeBag { get }
    
    func loadData(_ startId: Int?)
    func user(at index: Int) -> User?
}

extension InitialViewModelProtocol {
    func loadData(_ startId: Int? = 0) { loadData(startId) }
}
