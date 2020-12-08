//
//  ChannelExtension.swift
//  TinkoffChat
//
//  Created by Ildar on 11/11/20.
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
        if self.messages != nil {
            return description + "messages"
        } else {
            return description
        }
    }
}
