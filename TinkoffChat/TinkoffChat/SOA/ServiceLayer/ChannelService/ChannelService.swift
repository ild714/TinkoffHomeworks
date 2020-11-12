//
//  ServiceChannel.swift
//  TinkoffChat
//
//  Created by Ildar on 11/11/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData

protocol ChannelServiceStorageProtocol {
    func save(channels: [ChannelData], completion:@escaping () -> Void)
    var channelStorage: ChannelsStorageProtcol { get }
}

protocol ChannelServiceNetworkProtocol {
    func load(completion: @escaping ([ChannelData]) -> Void)
    func addChannel(name: String)
}

class ChannelService: ChannelServiceStorageProtocol, ChannelServiceNetworkProtocol {
    let channelStorage: ChannelsStorageProtcol
    let channelFireStore: ChannelsFireStoreProtocolol
    
    init(channelStorage: ChannelsStorageProtcol, channelFireStore: ChannelsFireStoreProtocolol) {
        self.channelStorage = channelStorage
        self.channelFireStore = channelFireStore
    }
    
    func load(completion: @escaping ([ChannelData]) -> Void) {
        channelFireStore.loadInitiaData {
            completion(self.channelFireStore.channelsArray)
        }
    }
    
    func addChannel(name: String) {
        channelFireStore.addChannel(name: name)
    }
    
    func save(channels: [ChannelData], completion:@escaping () -> Void) {
        channelStorage.saveChannels(channels: channels) {
            completion()
        }
    }
    
}
