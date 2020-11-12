//
//  ServicesAssembly.swift
//  TinkoffChat
//
//  Created by Ildar on 11/10/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

protocol ServicesAssemblyProtocol {
    var channelService: ChannelServiceStorageProtocol & ChannelServiceNetworkProtocol { get }
    var messagesService: MessagesServiceProtocol & MessagesServiceNetworkProtocol { get }
}

class ServiceAssembly: ServicesAssemblyProtocol {
    
    private let coreAssembly: CoreAssemblyProtocol
    
    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var channelService: ChannelServiceNetworkProtocol & ChannelServiceStorageProtocol = ChannelService(
        channelStorage: self.coreAssembly.storageChannels,
        channelFireStore: self.coreAssembly.fireStoreChannels)
    lazy var messagesService: MessagesServiceProtocol & MessagesServiceNetworkProtocol = MessagesService(
        messageStorage: self.coreAssembly.storageMessages,
        messagesFireStore: self.coreAssembly.fireStoreMessages)
}
