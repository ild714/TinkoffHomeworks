//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Ildar on 10/27/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var didUpdateDataBase: ((CoreDataStack) -> Void)?

    private var storeUrl: URL = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("dicument path not found")
        }
        return documentsUrl.appendingPathComponent("Chat.sqlite")
    }()
    
    private let dataModelName = "Chat"
    private let dataModelExtension = "momd"
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension) else {
            fatalError("model not found")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("managedObjectModel could not be created")
        }
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeUrl, options: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        return coordinator
    }()
    
    private lazy var writterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writterContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }
    
    func performSave(_ block: (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait {
            block(context)
            if context.hasChanges {
                do {
                    try performSave(in: context)
                } catch {
                    assertionFailure(error.localizedDescription)
                    
                }
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) throws {
        do {
            try context.save()
        } catch {
            assertionFailure(error.localizedDescription)
        }
        if let parent = context.parent {
            try performSave(in: parent)
        }
    }
    
    func enableObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChange(notification:)),
                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: mainContext)
    }
    
    @objc private func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        
        didUpdateDataBase?(self)
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            print("Added objects: ", inserts.count)
        }
        
        if let updates = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
            print("Updated objects: ", updates.count)
        }
        if let deleted = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deleted.count > 0 {
            print("Deleted objects", deleted.count)
        }
    }
    
    func printDataBaseInfo() {
        mainContext.perform {
            do {
                let count = try self.mainContext.count(for: ChannelDb.fetchRequest())
                print("\(count) channels")
                let array = try self.mainContext.fetch(ChannelDb.fetchRequest()) as? [ChannelDb] ?? []
                array.forEach {
                    print($0.about)
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
