//
//  ChatRequest.swift
//  TinkoffChat
//
//  Created by Ildar on 10/31/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData

class ChannelsCoreData: ChannelsStorageProtcol {
    let container: NSPersistentContainer?
    
    init(container: NSPersistentContainer?) {
        self.container = container
    }
    
    func saveChannels(channels: [ChannelData], completion:@escaping () -> Void) {
        if let container = self.container {
            for channel in channels {
                let group = DispatchGroup()
                group.enter()
                container.performBackgroundTask { (backgroundContext) in
                    backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                    let channelDb = ChannelDb(identifier: channel.identifier,
                                              name: channel.name,
                                              lastMessage: channel.lastMessage,
                                              lastActivity: channel.lastActivity, in: backgroundContext)
//                    print(channelDb)
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
                }
            }
        }
    }
}
