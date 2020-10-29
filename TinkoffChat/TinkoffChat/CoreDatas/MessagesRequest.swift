//
//  MessagesRequest.swift
//  TinkoffChat
//
//  Created by Ildar on 10/29/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData

struct MessagesRequest {
    let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func makeRequest(messages: [Message], id: String, channels: [Channel]) {
        
//        print(messages)
        var messagesDb = [MessageDb]()
        var channelsDb = [ChannelDb]()
        self.coreDataStack.performSave { (context) in
            
            for chanel in channels {
                
                let channelDb = ChannelDb(identifier: chanel.identifier,
                                          name: chanel.name,
                                          lastMessage: chanel.lastMessage,
                                          lastActivity: chanel.lastActivity ,
                                          in: context)
                channelsDb.append(channelDb)
            }
            
            for message in messages {
                let mes = MessageDb(content: message.content, created: message.created, senderId: message.senderId, senderName: message.senderName, in: context)
                messagesDb.append(mes)
            }
            
            for channel in channelsDb {
                if let channelId = channel.identifier {
                    if channelId == id {
//                        print(channelsDb)
//                        print(id)
                        messagesDb.forEach {
                            channel.addToMessages($0)
                        }
                    }
                }
            }
        }
    }
}
