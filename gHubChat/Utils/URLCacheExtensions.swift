//
//  NSURLCacheExtensions.swift
//  gHubChat
//
//  Created by Jahid Hassan on 9/1/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

extension URLCache {
    static func configSharedCache(directory: String? = Bundle.main.bundleIdentifier, memory: Int = 0, disk: Int = 0) {
        URLCache.shared = {
            let cacheDirectory = (NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String).appendingFormat("/\(directory ?? "cache")/" )
            return URLCache(memoryCapacity: memory, diskCapacity: disk, diskPath: cacheDirectory)
        }()
    }
}
