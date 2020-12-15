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
    func photoLoaderViewController() -> PhotoLoaderViewController?
}

class PresentationAssembly: PresentationAssemblyProtocol {
    
    private let serviceAssembly: ServicesAssemblyProtocol
    
    init(serviceAssembly: ServicesAssemblyProtocol) {
        self.serviceAssembly = serviceAssembly
    }
    
    func photoLoaderViewController() -> PhotoLoaderViewController? {
        if let imageLoader = PhotoLoaderViewController.storyboardInstance() {
            let model = imagesModel()
            imageLoader.model = model
            model.delegate = imageLoader
            return imageLoader
        }
        return nil
    }
    
    private func imagesModel() -> ImagesModel {
        return ImagesModel(imageService: self.serviceAssembly.imagesService)
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
