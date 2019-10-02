//
//  Store.swift
//  CoreDataPro
//
//  Created by Jahid Hassan on 8/21/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
import CoreData

class Store: StoreProtocol {
    private static let instance: StoreProtocol = Store()
    static var shared: StoreProtocol {
        return instance
    }
    
    private let storeName  = "gHubChat"
    private let entityName = "History"
    
    private let localStorage = UserDefaults.standard
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: storeName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveMessage(_ messages: [Message], for userId: Int) {
        let context = persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == \(userId)")
        request.returnsObjectsAsFaults = false
        
        var history = try? context.fetch(request).first as? History
        if history == nil {
            guard let entity = NSEntityDescription.entity(forEntityName: String(describing: History.self), in: context) else {
                return
            }
            
            history = History(entity: entity, insertInto: context)
            history?.setValue(userId, forKeyPath: "id")
        }
        history?.setValue(messages, forKey: "messages")
        
        saveContext()
    }
    
    func getMessages(id: Int) -> [Message] {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == \(id)")
        request.returnsObjectsAsFaults = false
        
        do {
            guard let history = try context.fetch(request).first as? History,
            let messages = history.messages as? [Message] else { return [] }
            
            return messages
        }
        catch {
            print("Fetching Failed")
        }
        
        return []
    }
    
    func clearCoreData() {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
        } catch let error {
            print("Detele all data in \(entityName) error :", error)
        }
    }
    
    // MARK: - local saving support
    func saveLastMessage(_ msg: String, for userId: Int) {
        localStorage.set(msg, forKey: "\(userId)")
        localStorage.synchronize()
    }
    
    func lastMessage(for userId: Int) -> String? {
        return localStorage.string(forKey: "\(userId)")
    }
    
    func clearAllLastMessage() {
        let dictionary = localStorage.dictionaryRepresentation()
        dictionary.keys.forEach { localStorage.removeObject(forKey: $0) }
        localStorage.synchronize()
    }
}
