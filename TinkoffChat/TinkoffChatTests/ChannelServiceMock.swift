//
//  ChannelServiceMock.swift
//  TinkoffChatTests
//
//  Created by Ildar on 11/29/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
@testable import TinkoffChat
import Firebase

final class ChannelServiceMock: ChannelServiceNetworkProtocol, ChannelServiceStorageProtocol {
    
    var callsCount = 0
    var callsCountSave = 0
    var loadChaneelsStub: ((([ChannelData]) -> Void) -> Void)!
    
    func load(completion: @escaping ([ChannelData]) -> Void) {
        UserDefaults.standard.set(true, forKey: "firstChannelOpen")
        callsCount += 1
        loadChaneelsStub(completion)
    }
    
    func save(channels: [ChannelData], completion: @escaping () -> Void) {
        callsCountSave += 1
        print("Saved channels")
    }
    
    var channelStorage: ChannelsStorageProtcol = ChannelsCoreData(container: AppDelegate.shared?.coreData.container)
    func addChannel(name: String) {
    }
}
