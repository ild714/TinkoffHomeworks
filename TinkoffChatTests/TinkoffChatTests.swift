//
//  TinkoffChatTests.swift
//  TinkoffChatTests
//
//  Created by Ildar on 11/29/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import XCTest
@testable import TinkoffChat
import Firebase

class TinkoffChatTests: XCTestCase {
    
    func testChannelServiceLoad() throws {
        // Arrange
        let channels = [ChannelData(dictionary: ["name": "Travel", "lastMessage": "Hello", "lastActivity": Timestamp(date: Date())], id: "1")!]
        let channelServiceMock = ChannelServiceMock()
        channelServiceMock.loadChaneelsStub = { completion in
            completion(channels)
        }
        
        let rootAssembly = RootAssembly()
        let vc = rootAssembly.presentationAssembly.converstationsListViewController()
        vc?.channelsService = channelServiceMock
        
        // Act
        vc?.viewWillAppear(true)
        
        // Assert
        XCTAssertEqual(channelServiceMock.callsCount, 1)
    }
    
    func testChannelServiceSave() throws {
        // Arrange
        let time = Date()
        let channels = [ChannelData(dictionary: ["name": "Travel", "lastMessage": "Hello", "lastActivity": Timestamp(date: time)], id: "1")!]
        let channelServiceMock2 = ChannelServiceMock()
        channelServiceMock2.loadChaneelsStub = { completion in
            completion(channels)
        }
        
        let rootAssembly = RootAssembly()
        let vc = rootAssembly.presentationAssembly.converstationsListViewController()
        vc?.channelsService = channelServiceMock2
        
        // Act
        vc?.viewWillAppear(true)
        
        // Assert
        XCTAssertEqual(channelServiceMock2.callsCountSave, 1)
        XCTAssertEqual(channelServiceMock2.channels[0].identifier, "1")
        XCTAssertEqual(channelServiceMock2.channels[0].lastActivity, Timestamp(date: time).dateValue())
        XCTAssertEqual(channelServiceMock2.channels[0].lastMessage, "Hello")
        XCTAssertEqual(channelServiceMock2.channels[0].name, "Travel")
    }
    
    func testCorrectChannelServiceLoad() {
        // Arrange
        let rootAssemblyMock = RootAssemblyMock()
        let vc = rootAssemblyMock.presentationAssembly.converstationsListViewController()
        
        // Act
        vc?.viewWillAppear(true)
        
        // Assert
        XCTAssertEqual(rootAssemblyMock.coreAssembly.fireStoreChannels.channelsArray.count, 1)
    }
    
    func testCorrectMessagesServiceLoad() {
        // Arrange
        let rootAssemblyMock = RootAssemblyMock()
        let vc = rootAssemblyMock.presentationAssembly.conversationViewController()
        vc?.channelId = "1"
        
        // Act
        vc?.viewWillAppear(true)
        
        // Assert
        XCTAssertEqual(rootAssemblyMock.coreAssembly.fireStoreMessages.messagesArray.count, 1)
        XCTAssertEqual(rootAssemblyMock.coreAssembly.fireStoreMessages.messagesArray[0].senderId, "1")
    }
}
