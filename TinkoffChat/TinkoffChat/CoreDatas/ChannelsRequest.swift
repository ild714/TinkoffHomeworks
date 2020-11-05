//
//  ChatRequest.swift
//  TinkoffChat
//
//  Created by Ildar on 10/31/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData

class ChannelsRequest {
    let coreData: ModernCoreDataStack?
    
    init(coreData: ModernCoreDataStack?) {
        self.coreData = coreData
    }
    
    func saveChannels(channels: [Channel], completion:@escaping () -> Void) {
        if let coreData = self.coreData {
            for channel in channels {
                let group = DispatchGroup()
                group.enter()
                coreData.container.performBackgroundTask { (backgroundContext) in
                    backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                    let channelDb = ChannelDb(identifier: channel.identifier,
                                              name: channel.name,
                                              lastMessage: channel.lastMessage,
                                              lastActivity: channel.lastActivity, in: backgroundContext)
                    print(channelDb)
                    if backgroundContext.hasChanges {
                        do {
                            try backgroundContext.save()
                        } catch {
                            
                        }
                    }
                    group.leave()
                }
                group.notify(queue: .main) {
                    completion()
                    print("Core data snapshot")
                }
            }
        }
    }
    
    func saveMessages(messages: [Message], id: String, completion:@escaping () -> Void) {
        let context1 = coreData?.container.viewContext
        let channels = try? context1?.fetch(ChannelDb.fetchRequest()) as? [ChannelDb] ?? []
        var channel: ChannelDb?
        
        if let channels = channels {
            for channelFromDb in channels where id == channelFromDb.identifier {
                channel = channelFromDb
            }
        }
        
        let group = DispatchGroup()
        if let coreData = self.coreData {
            var messagesFromDb = [MessageDb]()
            
            group.enter()
            coreData.container.performBackgroundTask { (backgroundContext) in
                
                for message in messages {
                    
                    backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                    let message = MessageDb(content: message.content, created: message.created, senderId: message.senderId, senderName: message.senderName, in: backgroundContext)
                    messagesFromDb.append(message)
                }
                if let objectId = channel?.objectID {
                    
                    let channelCotextBackground = backgroundContext.object(with: objectId) as? ChannelDb
                    channelCotextBackground?.messages = nil
                    messagesFromDb.forEach {channelCotextBackground?.addToMessages($0)}
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
