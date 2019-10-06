//
//  MessageViewModelProtocol.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/21/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

protocol MessageViewModelProtocol {
    var onUpdateMessage: ((IndexPath)->Void)? { get set }
    
    var messageCount: Int { get }
    
    var username: String { get }
    
    init(buddy: User, store: StoreProtocol)
    
    func loadStoreMessage()
    
    func message(at index: Int) -> Message?
    
    func sendMessage(_ msg: String)
    
    func layoutUpdated()
}

extension MessageViewModelProtocol {
    init(buddy: User) { self.init(buddy: buddy, store: Store.shared) }
}
