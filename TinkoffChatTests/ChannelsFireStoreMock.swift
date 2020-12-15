//
//  ChannelsFireStoreMock.swift
//  TinkoffChatTests
//
//  Created by Ildar on 12/3/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
@testable import TinkoffChat
import Firebase

class ChannelsFireStoreMock: ChannelsFireStoreProtocolol {
    
    var channelsArray: [ChannelData] = []
    
    func loadInitiaData(completed: @escaping () -> Void) {
        channelsArray = [ChannelData(dictionary: ["name": "Travel", "lastMessage": "Hello", "lastActivity": Timestamp(date: Date())], id: "1")!]
    }
    
    func addChannel(name: String) {
        
    }
    
}
