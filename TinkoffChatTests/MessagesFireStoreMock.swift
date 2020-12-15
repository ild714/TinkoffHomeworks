//
//  MessagesFireStoreMock.swift
//  TinkoffChatTests
//
//  Created by Ildar on 12/3/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
@testable import TinkoffChat
import Firebase

class MessagesFireStoreMock: MessagesFireStoreProtocolol {
    var messagesArray: [MessageData] = []
    
    func loadInitialData(channelId: String, completed: @escaping () -> Void) {
        messagesArray = [MessageData(dictionary: ["content": "test", "senderId": channelId, "senderName": "test", "created": Timestamp(date: Date())])!]
    }
    
    func addMessage(message: String, id: String) {
        
    }
}
