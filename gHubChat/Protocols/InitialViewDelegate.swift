//
//  InitialViewDelegate.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/21/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

protocol InitialViewDelegate {
    func willStartNetworkActivity()
    func didUpdatedData()
    func didFailedWithError(_ error: Error?)
}

extension InitialViewDelegate {
    func willStartNetworkActivity() {}
    func didFailedWithError(_ error: Error?) {}
}
