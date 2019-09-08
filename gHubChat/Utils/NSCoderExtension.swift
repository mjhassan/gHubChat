//
//  NSCoderExtension.swift
//  gHubChat
//
//  Created by Jahid Hassan on 9/8/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

extension NSCoder {
    subscript(key: String) -> String {
        get {
            return (self.decodeObject(forKey: key) as? String) ?? ""
        }
        set {
            self.encode(newValue, forKey: key)
        }
    }
    
    subscript(key: String) -> Bool {
        get {
            return self.decodeBool(forKey: key)
        }
        set {
            self.encode(newValue, forKey: key)
        }
    }
}
