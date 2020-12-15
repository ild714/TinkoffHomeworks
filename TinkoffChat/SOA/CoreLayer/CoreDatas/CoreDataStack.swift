//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Ildar on 10/27/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData

class ModernCoreDataStack {
    private let dataBaseName = "Chat"
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataBaseName)
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("something went wrong \(error) \(error.userInfo)")
            }
        }
        return container
    }()
}
