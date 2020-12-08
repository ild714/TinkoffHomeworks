//
//  MessagesStorageProtocol.swift
//  TinkoffChat
//
//  Created by Ildar on 11/11/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData

protocol MessageStorageProtcol {
    var container: NSPersistentContainer? { get }
    func saveMessages(messages: [MessageData], id: String, completion:@escaping () -> Void)
}
