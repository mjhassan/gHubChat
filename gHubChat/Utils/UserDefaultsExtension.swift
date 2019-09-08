//
//  UserDefaultsExtension.swift
//  gHubChat
//
//  Created by Jahid Hassan on 9/8/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

extension UserDefaults {
    subscript(key: String) -> String? {
        get {
            return self.string(forKey: key)
        }
        set {
            self.set(newValue, forKey: key)
            self.synchronize()
        }
    }
    
    func clearAll() {
        let dictionary = self.dictionaryRepresentation()
        dictionary.keys.forEach { self.removeObject(forKey: $0) }
        self.synchronize()
    }
}
