//
//  CoreAssemblyMock.swift
//  TinkoffChatTests
//
//  Created by Ildar on 12/3/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

@testable import TinkoffChat

class CoreAssemblyMock: CoreAssemblyProtocol {
   let container = AppDelegate.shared?.coreData.container
    
    lazy var storageChannels: ChannelsStorageProtcol = ChannelsCoreData(container: container)
    lazy var storageMessages: MessageStorageProtcol = MessagesCoreData(container: container)
    lazy var fireStoreChannels: ChannelsFireStoreProtocolol = ChannelsFireStoreMock()
    lazy var fireStoreMessages: MessagesFireStoreProtocolol = MessagesFireStoreMock()
    lazy var requestSender: RequestSenderProtocol = RequestSender(session: URLSession.shared)
}
