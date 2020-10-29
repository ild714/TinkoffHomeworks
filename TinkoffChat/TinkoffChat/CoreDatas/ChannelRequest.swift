//
//  ChannelRequest.swift
//  TinkoffChat
//
//  Created by Ildar on 10/27/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData

struct ChannelRequest {
    let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func makeRequest(channels: [Channel]) {
        coreDataStack.performSave { (context) in
            for chanel in channels {
                // Вопрос, как можно проигнорировать предупреждение в этом месте, если мы не используем переменную?
                let db = ChannelDb(identifier: chanel.identifier, name: chanel.name, lastMessage: chanel.lastMessage, lastActivity: chanel.lastActivity ?? Date(), in: context)
                //Строку ниже можно закомментировать во время проверки
                print(db)
            }
        }
    }
}
