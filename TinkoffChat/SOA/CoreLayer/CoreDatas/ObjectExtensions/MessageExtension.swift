//
//  MessageExtension.swift
//  TinkoffChat
//
//  Created by Ildar on 11/11/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData

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
