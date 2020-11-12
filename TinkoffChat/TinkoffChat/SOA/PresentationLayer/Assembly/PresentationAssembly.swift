//
//  PresentationAssembly.swift
//  TinkoffChat
//
//  Created by Ildar on 11/10/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

protocol PresentationAssemblyProtocol {
    func converstationsListViewController() -> ConversationsListViewController?
    func conversationViewController() -> ConversationViewController?
}

class PresentationAssembly: PresentationAssemblyProtocol {
    
    private let serviceAssembly: ServicesAssemblyProtocol
    
    init(serviceAssembly: ServicesAssemblyProtocol) {
        self.serviceAssembly = serviceAssembly
    }
    
    func converstationsListViewController() -> ConversationsListViewController? {
        if let vc = ConversationsListViewController.storyboardInstance() {
            vc.channelsService = serviceAssembly.channelService
            vc.container = serviceAssembly.channelService.channelStorage.container
            vc.presentationAssembly = self
            return vc
        } else {
            return nil
        }
    }
    
    func conversationViewController() -> ConversationViewController? {
        if let vc = ConversationViewController.storyboardInstance() {
            vc.messagesService = serviceAssembly.messagesService
            return vc
        } else {
            return nil
        }
    }
}
