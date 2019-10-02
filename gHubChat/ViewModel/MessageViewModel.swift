//
//  MessageViewModel.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/19/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class MessageViewModel: MessageViewModelProtocol {
    let messages: BehaviorRelay<[Message]>  = BehaviorRelay(value: [])
    let title: BehaviorRelay<String>        = BehaviorRelay(value: "")
    let lastIndexPath                       = PublishSubject<IndexPath>()
    let hiddenTextView                      = PublishSubject<Bool>()
    let disposeBag                          = DisposeBag()
    
    private let contact: BehaviorRelay<User>!
    private let store: StoreProtocol
    
    private var messageCount: Int {
        return messages.value.count
    }
    
    private var contactId: Int {
        return contact.value.id
    }
    
    private var contactLogin: String {
        return contact.value.login
    }
    
    private var contactAvatar: String {
        return contact.value.avatar_url
    }
    
    required init(buddy: User, store: StoreProtocol = Store.shared) {
        self.contact = BehaviorRelay(value: buddy)
        self.store   = store
        
        title.accept("@\(buddy.login)")
    }
    
    func loadStoreMessage() {
        let history = store.getMessages(id: contactId)
        messages.accept(messages.value + history)
        
        updatedLastIndex()
    }
    
    func message(at index: Int) -> Message? {
        return (index >= 0 && index < messageCount) ? messages.value[index]:nil
    }
    
    func sendMessage(_ msg: String) {
        let chat = Message(name: "me",
                           avater_url: "",
                           text: msg,
                           isRecieved: false)
        
        updateMessages(chat)
        triggerAutoReplay(msg)
    }
    
    func updatedLastIndex() {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now()+0.1) { [unowned self] in
            self.lastIndexPath.on(.next(IndexPath(item: self.messageCount - 1, section: 0)))
        }
    }
    
    func hideTextView(_ hidden: Bool = false) {
        hiddenTextView.on(.next(hidden))
    }
    
    private func triggerAutoReplay(_ msg: String) {
        DispatchQueue.global().asyncAfter(deadline: .now()+1) { [weak self] in
            guard let _ws = self else { return }
            
            let chat = Message(name: _ws.contactLogin,
                               avater_url: _ws.contactAvatar,
                               text: "\(msg) \(msg)",
                               isRecieved: true)
            _ws.updateMessages(chat)
        }
    }
    
    private func updateMessages(_ chat: Message) {
        self.messages.accept(messages.value + [chat])
        
        store.saveMessage(messages.value, for: contactId)
        store.saveLastMessage(chat.text, for: contactId)
        
        updatedLastIndex()
    }
    
    deinit {
        print("deinit - \(String(describing: self))")
    }
}
