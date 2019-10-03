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
// https://github.com/lanjing99/RxSwift2nd

import XCTest
import RxSwift
import RxTest
@testable import gHubChat

class InitialViewModelTests: XCTestCase {
    fileprivate var mockedVM : InitialViewModelProtocol!
    fileprivate var service: ServiceProtocol!
    fileprivate var scheduler: TestScheduler!
    fileprivate var disposeBag: DisposeBag!
    
    override func setUp() {
        service = FakeServices()
        mockedVM = InitialViewModel(service: service)
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        service = nil
        mockedVM = nil
        scheduler = nil
        disposeBag = nil
    }

    func test_emptyViewModel() {
        XCTAssertEqual(mockedVM.userCount, 0, "User should be empty as no data is loaded.")
        XCTAssertEqual(mockedVM.lastUserId, 0, "API paging should start from zero.")
        XCTAssertNil(mockedVM.user(at: 0), "User list should be empty.")
    }

    func test_forbidderFetching() {
        /*
        let expectation_time_out_sec = 10.0
        let expect = expectation(description: #function)
        var result: NetworkError!
        
        mockedVM.error
            .asObservable()
            .subscribe(onNext: { error in
                result = error
                expect.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: expectation_time_out_sec) { [unowned self] error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
            
            XCTAssertEqual(result, NetworkError.forbidden)
            XCTAssertEqual(self.mockedVM.list.value.count, 0, "User should be empty as no data is loaded.")
        }
        */
        
        mockedVM.error
        .subscribe(onNext: { [unowned self] error in
            XCTAssertEqual(error, NetworkError.forbidden)
            XCTAssertEqual(self.mockedVM.list.value.count, 0, "User should be empty as no data is loaded.")
        })
        .disposed(by: disposeBag)
        
        mockedVM.loadData(FakeServices.URLFlag.forbibben.rawValue)
    }
    
    func test_noDataFetching() {
        mockedVM.error
            .subscribe(onNext: { [unowned self] error in
                XCTAssertEqual(error, NetworkError.noData)
                XCTAssertEqual(self.mockedVM.list.value.count, 0, "User should be empty as no data is loaded.")
            })
            .disposed(by: disposeBag)
        
        mockedVM.loadData(FakeServices.URLFlag.noData.rawValue)
    }
    
    func test_customErrorFetching() {
        mockedVM.error
            .subscribe(onNext: { [unowned self] error in
                XCTAssertEqual(error, NetworkError.error("Custom error"))
                XCTAssertEqual(self.mockedVM.list.value.count, 0, "User should be empty as no data is loaded.")
            })
            .disposed(by: disposeBag)
        
        mockedVM.loadData(FakeServices.URLFlag.error.rawValue)
    }
    
    func test_dataFetching() {
        var onNextCalled        = 0
        var onErrorCalled       = 0
        var onCompletedCalled   = 0
        var onDisposedCalled    = 0
        
        mockedVM.error
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
        
        XCTAssertTrue(onNextCalled == 0)
        XCTAssertTrue(onErrorCalled == 0)
        XCTAssertTrue(onCompletedCalled == 0)
        XCTAssertTrue(onDisposedCalled == 0)
        
        onNextCalled        = 0
        onErrorCalled       = 0
        onCompletedCalled   = 0
        onDisposedCalled    = 0
        
        mockedVM.isLoading
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
        
        mockedVM.loadData(FakeServices.URLFlag.data.rawValue)
        
        XCTAssertTrue(onNextCalled == 2)
        XCTAssertTrue(onErrorCalled == 0)
        XCTAssertTrue(onCompletedCalled == 0)
        XCTAssertTrue(onDisposedCalled == 0)

        XCTAssertEqual(mockedVM.userCount, 1, "There should have one user.")
        XCTAssertEqual(mockedVM.lastUserId, 1)
        XCTAssertEqual(mockedVM.user(at: 0)?.avatar_url, "https://google.com/", "User list should be empty.")
    }
    
    /*
    func test_dataFetching() {
        mockedVM.loadData()
        
        let URL_TEMP: String = "https://api.github.com/users?since="
        let expectation = XCTestExpectation(description: "Fetch user list from github")
        let url = URL(string: "\(URL_TEMP)0")!
        
        let localMock = mockedVM
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, _) in
            XCTAssertNotNil(data, "No data was downloaded.")
            
            expectation.fulfill()
            
            guard let models = try? JSONDecoder().decode([User].self, from: data!) else { return }
            XCTAssertNotNil(models, "No model was decoded.")
            
            XCTAssertEqual(localMock?.userCount, models.count, "Number of user should be same")
            XCTAssertEqual(localMock?.lastUserId, models.last?.id, "Data should match as expected")
        }
        dataTask.resume()
        
        wait(for: [expectation], timeout: 60.0)
    }
 */
}
