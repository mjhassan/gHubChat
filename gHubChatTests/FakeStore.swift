//
//  FakeStore.swift
//  gHubChatTests
//
//  Created by Jahid Hassan on 10/2/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import XCTest
import CoreData
@testable import gHubChat

class FakeStore: StoreProtocol {
    static var shared: StoreProtocol = Store()
    
    var saveContextCalled = 0
    var saveMessageCalled = 0
    var clearCoreDataCalled = 0
    var saveLastMessageCalled = 0
    var clearAllMessagesCalled = 0
    var messages: [Message] = []
    
    func saveContext() {
        saveContextCalled += 1
    }
    
    func saveMessage(_ message: [Message], for user: Int) {
        messages.append(contentsOf: message)
        saveMessageCalled += 1
    }
    
    func getMessages(id: Int) -> [Message] {
        return messages
    }
    
    func clearCoreData() {
        clearCoreDataCalled += 1
    }
    
    func saveLastMessage(_ msg: String, for userId: Int) {
        saveLastMessageCalled += 1
    }
    
    func lastMessage(for userId: Int) -> String? {
        return messages.last?.text
    }
    
    func clearAllLastMessage() {
        clearAllMessagesCalled += 1
    }
}
