//
//  gHubChatTests.swift
//  gHubChatTests
//
//  Created by Jahid Hassan on 8/19/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import XCTest
@testable import gHubChat

class InitialViewModelTests: XCTestCase {

    fileprivate var delegate : MockInitialViewDelegate!
    fileprivate var mockedVM : InitialViewModelProtocol!
    
    override func setUp() {
        delegate = MockInitialViewDelegate()
        mockedVM = InitialViewModel(bind: delegate)
    }

    override func tearDown() {
        delegate = nil
        mockedVM = nil
    }

    func test_emptyViewModel() {
        XCTAssertEqual(mockedVM.userCount, 0, "User should be empty as no data is loaded.")
        XCTAssertEqual(mockedVM.lastUserId, 0, "API paging should start from zero.")
        XCTAssertNil(mockedVM.user(at: 0), "User list should be empty.")
    }

    func test_dataFetching() {
        mockedVM.loadData()
        
        XCTAssertTrue(delegate.calledWillStartNetworkActivity, "Activity will show on data fetch")
        
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
}
