//
//  gHubChatUITests.swift
//  gHubChatUITests
//
//  Created by Jahid Hassan on 8/24/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import XCTest

class gHubChatUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
        
        app.launch()
    }

    override func tearDown() {
        app = nil
    }
    
    func testInitialViewControllerComponenets() {
        let tableView = app.tables.containing(.table, identifier: "userList")
        XCTAssertNotNil(tableView)
//        XCTAssert(tableView.cells.count == 0)
    }

    func testExample() {
//        XCUIApplication().tables.cells.containing(.staticText, identifier:"@mojombo").staticTexts["Hi there! I'm using gHubChat."].tap()
        
    }

}
