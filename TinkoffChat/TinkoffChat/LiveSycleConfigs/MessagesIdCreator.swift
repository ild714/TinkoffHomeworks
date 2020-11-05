//
//  messagesIdCreator.swift
//  TinkoffChat
//
//  Created by Ildar on 10/19/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

class MessagesIdCreator {
    
    static var idUser: String {
        let id = UserDefaults.standard.object(forKey: "userIdForMessages") as? String
        if let id = id {
            return id
        } else {
            let userIdForMessages = UUID().uuidString
            UserDefaults.standard.set(userIdForMessages, forKey: "userIdForMessages")
            return userIdForMessages
        }
    }
}
