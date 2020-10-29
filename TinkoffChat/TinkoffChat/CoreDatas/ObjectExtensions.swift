//
//  ObjectExtensions.swift
//  TinkoffChat
//
//  Created by Ildar on 10/27/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData

extension ChannelDb {
    convenience init(identifier: String, name: String, lastMessage: String?, lastActivity: Date?, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage ?? ""
        self.lastActivity = lastActivity ?? Date()
    }
    
    var about: String {
        let description = "\(String(describing: name))--- Chanel Name\n"
        let messages = self.messages?.allObjects.compactMap { $0 as? MessageDb}.map {"\t\($0.about)"}.joined(separator: "\n") ?? ""
        return description + messages 
    }
}

extension MessageDb {
    convenience init(content: String, created: Date, senderId: String, senderName: String, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
    
    var about: String {
        return self.content
    }
}
