//
//  StoreProtocol.swift
//  CoreDataPro
//
//  Created by Jahid Hassan on 8/21/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
import CoreData

protocol StoreProtocol {
    static var shared: StoreProtocol { get }
    
    // core data support
    var persistentContainer: NSPersistentContainer { get }
    
    func saveContext ()
    func saveMessage(_ message: [Message], for user: Int)
    func getMessages(id: Int) -> [Message]
    func clearCoreData()
    
    // user default support
    func saveLastMessage(_ msg: String, for userId: Int)
    func lastMessage(for userId: Int) -> String?
    func clearAllLastMessage()
}
