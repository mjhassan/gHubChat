//
//  MessageViewModelTests.swift
//  gHubChatTests
//
//  Created by Jahid Hassan on 8/20/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import RxTest
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
        mockStore = nil
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
        
        do {
            guard let messages = try mockedVM.messages.toBlocking(timeout: 1.0).first() else { return }
            XCTAssertEqual(messages.count, 0)
            
            guard let user = try mockedVM.title.toBlocking(timeout: 1.0).first() else { return }
            XCTAssertEqual(user, "@\(username)")
            
            XCTAssertNil(mockedVM.message(at: 0))
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func test_singleSendMessage() {
        let disposeBag = DisposeBag()
        let send_timeout = 1.0
        let response_timeout = 5.0
        let txt = "Hi"
        let expectedMsg = Message(name: "me", avater_url: "", text: txt, isRecieved: false)
        let expectedResponse = Message(name: username, avater_url: "https", text: "\(txt) \(txt)", isRecieved: true)
        
        mockedVM.sendMessage(txt)
        
        do {
            guard let messages = try mockedVM.messages.toBlocking(timeout: send_timeout).first() else { return }
            XCTAssertEqual(messages.count, 1)
            
            guard let indexPath = try mockedVM.lastIndexPath.toBlocking(timeout: send_timeout).first() else { return }
            XCTAssertEqual(indexPath, IndexPath(row: 0, section: 0))
            
            let result = mockedVM.message(at: 0)
            XCTAssertNotNil(result)
            XCTAssert(result! == expectedMsg)
            
            guard let indexPathResponse = try mockedVM.lastIndexPath.toBlocking(timeout: response_timeout).first() else { return }
            XCTAssertEqual(indexPathResponse, IndexPath(row: 1, section: 0))
            
            let expect = expectation(description: #function)
            var _messages: [Message]!
            mockedVM.messages
                .asObservable()
                .subscribe(onNext: {
                    _messages = $0
                    expect.fulfill()
                })
                .disposed(by: disposeBag)
            
            waitForExpectations(timeout: response_timeout) { [unowned self] error in
                guard error == nil else {
                    fatalError(error!.localizedDescription)
                }
                
                XCTAssertEqual(_messages.count, 2)
                
                let resultResponse = self.mockedVM.message(at: 1)
                XCTAssertNotNil(resultResponse)
                XCTAssert(resultResponse! == expectedResponse)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func test_history() {
        let send_timeout = 1.0
        let txt = "Some text"
        let message = Message(name: "me", avater_url: "", text: txt, isRecieved: false)
        
        mockStore.messages.append(message)
        
        mockedVM.loadStoreMessage()
        
        do {
            guard let messages = try mockedVM.messages.toBlocking(timeout: send_timeout).first() else { return }
            XCTAssertEqual(messages.count, 1)
            XCTAssert(mockedVM.message(at: 0)! == message)
            
            guard let indexPath = try mockedVM.lastIndexPath.toBlocking(timeout: send_timeout).first() else { return }
            XCTAssertEqual(indexPath, IndexPath(row: 0, section: 0))
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func test_hideTextView() {
        var onNextCalled = 0
        var lastValue: Bool!
        
        mockedVM.hiddenTextView
            .asObservable()
            .subscribe(onNext: { n in
                    lastValue = n
                    onNextCalled += 1
            })
            .disposed(by: disposeBag)
        
        mockedVM.hideTextView()
        mockedVM.hideTextView(true)
        
        XCTAssertTrue(onNextCalled == 2)
        XCTAssert(lastValue == true)
    }
}
