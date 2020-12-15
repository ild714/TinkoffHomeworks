//
//  MessagesService.swift
//  TinkoffChat
//
//  Created by Ildar on 11/11/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol MessagesServiceProtocol {
    func save(messages: [MessageData], id: String, completion:@escaping () -> Void)
}

protocol MessagesServiceNetworkProtocol {
    func load(channelId: String, completion: @escaping ([MessageData]) -> Void)
    func addMessage(message: String, id: String)
}

class MessagesService: MessagesServiceProtocol, MessagesServiceNetworkProtocol {
    private let messageStorage: MessageStorageProtcol
    let messagesFireStore: MessagesFireStoreProtocolol
    
    init(messageStorage: MessageStorageProtcol, messagesFireStore: MessagesFireStoreProtocolol) {
        self.messageStorage = messageStorage
        self.messagesFireStore = messagesFireStore
    }
    
    func load(channelId: String, completion: @escaping ([MessageData]) -> Void) {
        messagesFireStore.loadInitialData(channelId: channelId) {
            completion(self.messagesFireStore.messagesArray)
        }
    }
    
    func addMessage(message: String, id: String) {
        messagesFireStore.addMessage(message: message, id: id)
    }
    
    func save(messages: [MessageData], id: String, completion:@escaping () -> Void) {
        messageStorage.saveMessages(messages: messages, id: id) {
            completion()
        }
    }
}
