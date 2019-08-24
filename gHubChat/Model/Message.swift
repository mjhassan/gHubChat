//
//  Message.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/20/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

class Message: NSObject, NSCoding, Codable {
    let name: String
    let avater_url: String
    let text: String
    let isRecieved: Bool
    
    // class initializer; Duh! 😩
    init(name: String, avater_url: String, text: String, isRecieved: Bool) {
        self.name       = name
        self.avater_url = avater_url
        self.text       = text
        self.isRecieved = isRecieved
    }
    
    // NSCoding Protocol
    struct Keys {
        static let name         = "name"
        static let avater_url   = "avater_url"
        static let text         = "text"
        static let isRecieved   = "isRecieved"
    }
    
    // stubs
    required init?(coder aDecoder: NSCoder) {
        self.name       = (aDecoder.decodeObject(forKey: Keys.name) as? String) ?? ""
        self.avater_url = (aDecoder.decodeObject(forKey: Keys.avater_url) as? String) ?? ""
        self.text       = (aDecoder.decodeObject(forKey: Keys.text) as? String) ?? ""
        self.isRecieved = aDecoder.decodeBool(forKey: Keys.isRecieved)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: Keys.name)
        aCoder.encode(self.avater_url, forKey: Keys.avater_url)
        aCoder.encode(self.text, forKey: Keys.text)
        aCoder.encode(self.isRecieved, forKey: Keys.isRecieved)
    }
    
    // overrding Equitable
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.name == rhs.name
            && lhs.avater_url == rhs.avater_url
            && lhs.text == rhs.text
            && lhs.isRecieved == rhs.isRecieved
    }
}
