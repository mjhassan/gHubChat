//
//  MockInitialViewDelegate.swift
//  gHubChatTests
//
//  Created by Jahid Hassan on 8/21/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
@testable import gHubChat

class MockInitialViewDelegate: InitialViewDelegate {
    public var calledWillStartNetworkActivity: Bool = false
    public var calledDidUpdateData: Bool = false
    public var calledDidFailedWithError: Bool = false
    public var error: Error? = nil
    
    func willStartNetworkActivity() {
        calledWillStartNetworkActivity = true
    }
    
    func didUpdatedData() {
        calledDidUpdateData = true
    }
    
    func didFailedWithError(_ error: Error?) {
        calledDidFailedWithError = true
        self.error = error
    }
}
