//
//  User.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/19/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

struct User: Codable, Identifiable {
    let login: String
    let id: Int
    let avatar_url: String
}
