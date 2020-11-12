//
//  MessagesRequest.swift
//  TinkoffChat
//
//  Created by Ildar on 11/9/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData

class MessagesCoreData: MessageStorageProtcol {
    let container: NSPersistentContainer?
    
    init(container: NSPersistentContainer?) {
        self.container = container
    }
    
    func saveMessages(messages: [MessageData], id: String, completion:@escaping () -> Void) {
        let context1 = container?.viewContext
        
        let channels = try? context1?.fetch(ChannelDb.fetchRequest()) as? [ChannelDb] ?? []
        var channel: ChannelDb?
        
        if let channels = channels {
            for channelFromDb in channels where id == channelFromDb.identifier {
                channel = channelFromDb
            }
        }
        
        let group = DispatchGroup()
        if let container = self.container {
            var messagesFromDb = [MessageDb]()
            
            group.enter()
            container.performBackgroundTask { (backgroundContext) in
                
                for message in messages {
                    
                    let message = MessageDb(content: message.content, created: message.created, senderId: message.senderId, senderName: message.senderName, in: backgroundContext)
                    messagesFromDb.append(message)
                }
                if let objectId = channel?.objectID {
                    
                    let channel = backgroundContext.object(with: objectId) as? ChannelDb
                    channel?.messages = nil
                    messagesFromDb.forEach {channel?.addToMessages($0)}
                }
                if backgroundContext.hasChanges {
                    do {
                        try backgroundContext.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                group.leave()
            }
            group.notify(queue: .main) {
                completion()
            }
        }
    }
}
