//
//  CoreAssembly.swift
//  TinkoffChat
//
//  Created by Ildar on 11/11/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol CoreAssemblyProtocol {
    var storageChannels: ChannelsStorageProtcol { get }
    var storageMessages: MessageStorageProtcol { get }
    var fireStoreChannels: ChannelsFireStoreProtocolol { get }
    var fireStoreMessages: MessagesFireStoreProtocolol { get }
}

class CoreAssembly: CoreAssemblyProtocol {
    let container = AppDelegate.shared?.coreData.container
    
    lazy var storageChannels: ChannelsStorageProtcol = ChannelsCoreData(container: container)
    lazy var storageMessages: MessageStorageProtcol = MessagesCoreData(container: container)
    lazy var fireStoreChannels: ChannelsFireStoreProtocolol = ChannelsFireStore()
    lazy var fireStoreMessages: MessagesFireStoreProtocolol = MessagesFireStore()
}
