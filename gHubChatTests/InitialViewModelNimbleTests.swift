//
//  gHubChatTests.swift
//  gHubChatTests
//
//  Created by Jahid Hassan on 8/19/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

// https://saadeloulladi.com/ios-swift-mvvm-rxswift-unit-testing/
// https://bit.ly/2pjgxWb
// https://medium.com/vincit/unit-testing-rxswift-application-f0c6ea460429
// https://github.com/RxSwiftCommunity/RxNimble/blob/master/RxNimbleTests/RxNimbleRxBlockingTests.swift

import Quick
import Nimble
import RxTest
import RxSwift
import RxNimbleRxBlocking
import RxNimbleRxTest
@testable import gHubChat

class InitialViewModelNimbleTests: QuickSpec {
    /*
    override func spec() {
        var mockedVM : InitialViewModelProtocol!
        var service: ServiceProtocol!
        var disposeBag: DisposeBag!
        var scheduler: TestScheduler!
        
        let initialClock = 0
        
        describe("InitialViewModel") {
            context("Ensure all properties are working") {
                beforeEach {
                    service = FakeServices()
                    mockedVM = InitialViewModel(service: service)
                    
                    disposeBag = DisposeBag()
                    scheduler = TestScheduler(initialClock: initialClock, simulateProcessingDelay: true)
                }
                
                afterEach {
                    service = nil
                    mockedVM = nil
                    
                    disposeBag = nil
                    scheduler = nil
                }
                
                it("should initialize viewmodel properties correctly") {
                    expect(mockedVM.userCount).to(equal(0))
                    expect(mockedVM.lastUserId).to(equal(0))
                    expect(mockedVM.user(at: 0)).to(beNil())
                }
                
                it("should be able to raise forbidden error") {
                    mockedVM.loadData(FakeServices.URLFlag.forbibben.rawValue)
                    
                    expect(mockedVM.list.value.count).to(equal(0))
                    expect(mockedVM.error)
                        .events(scheduler: scheduler, disposeBag: disposeBag)
                        .to(equal([
                            Recorded.error(30, NetworkError.forbidden)
                        ]))
                }
                
                it("should be able to raise no data error") {
                    mockedVM.loadData(FakeServices.URLFlag.noData.rawValue)
                    
                    expect(mockedVM.list.value.count).to(equal(0))
                    expect(mockedVM.error)
                        .events(scheduler: scheduler, disposeBag: disposeBag, startAt: 60)
                        .to(equal([
                            Recorded.error(30, NetworkError.noData)
                        ]))
                }
                
                it("should be able to raise custom error") {
                    let eventTime = 30
                    let subject = scheduler.createColdObservable([
                        .next(eventTime, mockedVM.loadData(FakeServices.URLFlag.error.rawValue))
                    ])
                    
                    expect(mockedVM.list.value.count).to(equal(0))
                    expect(subject)
                        .events(scheduler: scheduler, disposeBag: disposeBag)
                        .to(equal(Recorded.error(eventTime, NetworkError.error("Custom error"))))
                }
                
                it("should fetch data") {
                    mockedVM.loadData(FakeServices.URLFlag.data.rawValue)
                    
                    expect(mockedVM.error)
                    .events(scheduler: scheduler, disposeBag: disposeBag, startAt: 60)
                    .to(equal([]))
                    
                    expect(mockedVM.isLoading).events(scheduler: scheduler, disposeBag: disposeBag)
                    .to(equal([
                        Recorded.next(0, true),
                        Recorded.next(30, false)
                    ]))
                    
                    expect(mockedVM.userCount).to(equal(1))
                    expect(mockedVM.lastUserId).to(equal(1))
                    expect(mockedVM.user(at: 0)?.avatar_url).to(equal("https://google.com/"))
                }
            }
        }
    }
     */
}
