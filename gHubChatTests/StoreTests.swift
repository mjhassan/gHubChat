//
//  StoreTests.swift
//  gHubChatTests
//
//  Created by Jahid Hassan on 8/21/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import XCTest
import CoreData

@testable import gHubChat

class StoreTests: XCTestCase {
    // core data
    fileprivate let storeName  = "gHubChat"
    fileprivate let entityName = "History"
    
    fileprivate lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: storeName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    fileprivate var mockStore: StoreProtocol!
    fileprivate var context: NSManagedObjectContext!
    
    fileprivate let send: Message       = Message(name: "x", avater_url: "https", text: "Hello", isRecieved: false)
    fileprivate let recieved: Message   = Message(name: "y", avater_url: "https", text: "Hello Hello", isRecieved: true)
    
    // user default
    fileprivate var userDefaults: UserDefaults!
    
    override func setUp() {
        mockStore = Store()
        context = persistentContainer.viewContext
        
        userDefaults = UserDefaults.standard
    }

    override func tearDown() {
        Store.shared.clearCoreData()
        userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        
        mockStore = nil
        context = nil
        userDefaults = nil
    }
    
    func test_saveContext_saveMessage() {
        let targetId = 0
        let expected = [send, recieved]
        
        mockStore.saveMessage(expected, for: targetId)
        
        let result = Store.shared.getMessages(id: targetId)
        
        XCTAssertEqual(result.count, expected.count, "Expecting same number messages as saved")
        XCTAssertTrue(result.first! == send && result.last! == recieved, "Expecting same object at same index")
    }
    
    func test_getMessages() {
        let targetId = 0
        let expected = [send, recieved]
        
        Store.shared.saveMessage(expected, for: targetId)
        let result = mockStore.getMessages(id: targetId)
        
        XCTAssertEqual(result.count, expected.count, "Expecting same number messages as saved")
        XCTAssertTrue(result.first! == send && result.last! == recieved, "Expecting same object at same index")
    }
    
    
    func test_clearCoreData() {
        let targetId = 0
        let expected = [send, recieved]
        
        Store.shared.saveMessage(expected, for: targetId)
        mockStore.clearCoreData()
        let result = Store.shared.getMessages(id: targetId)
        
        XCTAssert(result.count == 0, "All message should have cleared")
    }
    
    //local storage support test
    func test_saveLastMessage() {
        let expectedMessage = "Hello World!"
        let expectedUserId = Int.max
        
        mockStore.saveLastMessage(expectedMessage, for: expectedUserId)
        let result = userDefaults.string(forKey: "\(expectedUserId)")
        
        XCTAssertEqual(result!, expectedMessage)
    }
    
    func test_clearAllLastMessage() {
        let message = "Hello World!"
        let key = "\(Int.max)"
        
        userDefaults.set(message, forKey: key)
        mockStore.clearAllLastMessage()
        let result = userDefaults.string(forKey: key)
        
        XCTAssertNil(result)
    }
    
    func test_lastMessage() {
        let expectedMessage = "Hello World!"
        let expectedUserId = Int.max
        
        userDefaults.set(expectedMessage, forKey: "\(expectedUserId)")
        let result = mockStore.lastMessage(for: expectedUserId)
        
        XCTAssertEqual(result!, expectedMessage)
    }
}
