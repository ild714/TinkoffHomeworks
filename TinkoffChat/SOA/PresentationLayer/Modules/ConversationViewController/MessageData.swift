//
//  Message.swift
//  TinkoffChat
//
//  Created by Ildar on 10/19/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import Firebase

struct MessageData {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    
    init?(dictionary: [String: Any]) {
        if let content = dictionary["content"] as? String {
            self.content = content
        } else {
            return nil
        }
        if let senderId = dictionary["senderId"] as? String {
            self.senderId = senderId
        } else {
            return nil
        }
        
        if let senderName = dictionary["senderName"] as? String {
            self.senderName = senderName
        } else {
            return nil
        }
        
        let dateTimeStamp = dictionary["created"] as? Timestamp ?? nil
        if let date = dateTimeStamp?.dateValue() {
             created = date
        } else {
            return nil
        }
    }
}
