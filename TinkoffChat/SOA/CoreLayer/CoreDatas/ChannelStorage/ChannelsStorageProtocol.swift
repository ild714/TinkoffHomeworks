//
//  StorageProtocol.swift
//  TinkoffChat
//
//  Created by Ildar on 11/11/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
import CoreData

protocol ChannelsStorageProtcol {
    var container: NSPersistentContainer? { get }
    func saveChannels(channels: [ChannelData], completion:@escaping () -> Void)
}
