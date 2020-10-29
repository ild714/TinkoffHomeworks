//
//  SortedPeople.swift
//  TinkoffChat
//
//  Created by Ildar on 10/7/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
import Firebase

struct Channel {
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    let identifier: String
    
    init?(dictionary: [String: Any], id: String) {
        if let name = dictionary["name"] as? String {
            self.name = name
        } else {
            return nil
        }
        
        if let lastMessage = dictionary["lastMessage"] as? String {
            self.lastMessage = lastMessage
        } else {
            return nil
        }
        
        let dateTimeStamp = dictionary["lastActivity"] as? Timestamp ?? nil
        if let date = dateTimeStamp?.dateValue() {
            lastActivity = date
        } else {
            lastActivity = nil
        }
        identifier = id
    }
}
