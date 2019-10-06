//
//  MessageViewModel.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/19/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

class MessageViewModel: MessageViewModelProtocol {
    private let contact: User
    private(set) var messages: [Message] = []
    private let store: StoreProtocol!
    
    public var onUpdateMessage: ((IndexPath)->Void)? = nil
    
    public var messageCount: Int {
        return messages.count
    }
    
    public var username: String {
        return "@\(contact.login)"
    }
    
    private var lastIndexPath: IndexPath {
        return IndexPath(item: self.messages.count - 1, section: 0)
    }
    
    required init(buddy: User, store: StoreProtocol) {
        self.contact = buddy
        self.store = store
    }
    
    func loadStoreMessage() {
        let history = store.getMessages(id: contact.id)
        messages.append(contentsOf: history)
    }
    
    func message(at index: Int) -> Message? {
        return (index >= 0 && index < messageCount) ? messages[index]:nil
    }
    
    func sendMessage(_ msg: String) {
        let chat = Message(name: "me",
                           avater_url: "",
                           text: msg,
                           isRecieved: false)
        
        updateMessages(chat)
        triggerAutoReplay(msg)
    }
    
    func layoutUpdated() {
        onUpdateMessage?(lastIndexPath)
    }
    
    private func triggerAutoReplay(_ msg: String) {
        DispatchQueue.global().asyncAfter(deadline: .now()+1) { [weak self] in
            guard let weakSelf = self else { return }
            
            let chat = Message(name: weakSelf.contact.login,
                               avater_url: weakSelf.contact.avatar_url,
                               text: "\(msg) \(msg)",
                               isRecieved: true)
            weakSelf.updateMessages(chat)
        }
    }
    
    private func updateMessages(_ chat: Message) {
        self.messages.append(chat)
        
        store.saveMessage(messages, for: contact.id)
        store.saveLastMessage(chat.text, for: contact.id)
        
        onUpdateMessage?(lastIndexPath)
    }
    
    deinit {
        print("deinit - \(String(describing: self))")
        messages.removeAll()
    }
}
