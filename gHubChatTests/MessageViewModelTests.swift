//
//  MessageViewModelTests.swift
//  gHubChatTests
//
//  Created by Jahid Hassan on 8/20/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import XCTest
import RxSwift
@testable import gHubChat

class MessageViewModelTests: XCTestCase {
    fileprivate var mockedVM : MessageViewModelProtocol!
    fileprivate var mockStore: FakeStore!
    fileprivate let disposeBag  = DisposeBag()
    fileprivate let username    = "x"
    fileprivate let id: Int     = Int.max
    
    override func setUp() {
        mockStore = FakeStore()
        mockedVM = MessageViewModel(buddy: User(login: username, id: id, avatar_url: "https"), store: mockStore)
    }

    override func tearDown() {
        mockedVM = nil
    }
    
    func test_initialization() {
        var onNextCalled = 0
        var onErrorCalled = 0
        var onCompletedCalled = 0
        var onDisposedCalled = 0
        
        mockedVM.title
            .subscribe(onNext: { n in
                    onNextCalled += 1
                }, onError: { e in
                    onErrorCalled += 1
                }, onCompleted: {
                    onCompletedCalled += 1
                }, onDisposed: {
                    onDisposedCalled += 1
                })
            .disposed(by: disposeBag)
        
            XCTAssertTrue(onNextCalled == 1)
            XCTAssertTrue(onErrorCalled == 0)
            XCTAssertTrue(onCompletedCalled == 0)
            XCTAssertTrue(onDisposedCalled == 0)
        
//        XCTAssertEqual(mockedVM.messageCount, 0, "Initial message count should be zero")
//        XCTAssertEqual(mockedVM.username, "@\(username)", "Username should be matched")
//        XCTAssertNil(mockedVM.message(at: 0), "Initially there shouldn't be any message")
    }

//    func test_singleSendMessage() {
//        mockStore.clearCoreData()
//        
//        let txt = "Hi"
//        let expectedMsg = Message(name: "me", avater_url: "", text: txt, isRecieved: false)
//        let expectedResponse = Message(name: username, avater_url: "https", text: "\(txt) \(txt)", isRecieved: true)
//        
//        mockedVM.sendMessage(txt)
//        
//        let result = mockedVM.message(at: 0)
//        
//        XCTAssertNil(mockedVM.onUpdateMessage)
//        XCTAssertEqual(mockedVM.messageCount, 1, "Message count should be 1")
//        XCTAssertNotNil(result, "Message should not be empty")
//        XCTAssert(result! == expectedMsg, "Expected message is not equal after sending")
//        
//        let exp = expectation(description: "Demo auto-replay will append in messages list")
//        DispatchQueue.global().asyncAfter(deadline: .now()+5) {
//            exp.fulfill()
//            
//            let result = self.mockedVM.message(at: 1)
//            
//            XCTAssertNil(self.mockedVM.onUpdateMessage)
//            XCTAssertEqual(self.mockedVM.messageCount, 2, "Message count should be 2, with auto replay")
//            XCTAssertNotNil(result, "Response message should not be nil")
//            XCTAssert(result! == expectedResponse, "Response should match")
//        }
//        
//        wait(for: [exp], timeout: 10)
//    }
//    
//    func test_callbackClosure() {
//        mockStore.clearCoreData()
//        
//        let txt = "Hi"
//        var _indexPath: IndexPath? = nil
//        let expectedIndexPath1 = IndexPath(row: 0, section: 0)
//        let expectedIndexPath2 = IndexPath(row: 1, section: 0)
//        let callback: (IndexPath) -> Void = { indexPath in
//            _indexPath = indexPath
//        }
//        
//        mockedVM.onUpdateMessage = callback
//        
//        XCTAssertNil(_indexPath)
//        mockedVM.sendMessage(txt)
//        
//        XCTAssertNotNil(mockedVM.onUpdateMessage)
//        XCTAssertNotNil(_indexPath)
//        XCTAssertEqual(_indexPath, expectedIndexPath1, "IndexPath should match on callback invoked")
//        
//        let exp = expectation(description: "Demo auto-replay will append in messages list")
//        DispatchQueue.global().asyncAfter(deadline: .now()+5) {
//            exp.fulfill()
//            
//            XCTAssertEqual(_indexPath, expectedIndexPath2, "Response indexPath should match on callback invoked")
//        }
//        
//        wait(for: [exp], timeout: 10)
//    }
//    
//    func test_layoutUpdate() {
//        let txt = "Hi"
//        var _indexPath: IndexPath? = nil
//        let expectedIndexPath = IndexPath(row: 0, section: 0)
//        
//        let callback = { indexPath in
//            _indexPath = indexPath
//        }
//        
//        mockedVM.onUpdateMessage = callback
//        
//        mockedVM.sendMessage(txt)
//        mockedVM.layoutUpdated()
//        
//        XCTAssertEqual(_indexPath, expectedIndexPath, "IndexPath should match on callback invoked")
//    }
//    
//    func test_history() {
//        let txt = "Some text"
//        let message = Message(name: "me", avater_url: "", text: txt, isRecieved: false)
//        let response = Message(name: username, avater_url: "https", text: "\(txt) \(txt)", isRecieved: true)
//        
//        let messages = [message, response]
//        
//        Store.shared.saveMessage(messages, for: id)
//        mockedVM.loadStoreMessage()
//        
//        let expectedResponse = mockedVM.message(at: messages.count - 1)
//        
//        XCTAssertEqual(mockedVM.messageCount, messages.count, "Expecting same number messages as saved")
//        XCTAssertEqual(response, expectedResponse!, "Expecting same object at same index")
//    }
}
