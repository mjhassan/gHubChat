//
//  Message.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/20/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

class Message: NSObject, NSCoding {
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
        self.name       = aDecoder[Keys.name]
        self.avater_url = aDecoder[Keys.avater_url]
        self.text       = aDecoder[Keys.text]
        self.isRecieved = aDecoder[Keys.isRecieved]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder[Keys.name]       = self.name
        aCoder[Keys.avater_url] = self.avater_url
        aCoder[Keys.text]       = self.text
        aCoder[Keys.isRecieved] = self.isRecieved
    }
    
    // overrding Equitable
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.name == rhs.name
            && lhs.avater_url == rhs.avater_url
            && lhs.text == rhs.text
            && lhs.isRecieved == rhs.isRecieved
    }
}
