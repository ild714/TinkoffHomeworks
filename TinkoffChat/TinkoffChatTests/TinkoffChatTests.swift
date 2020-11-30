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
        let channels = [ChannelData(dictionary: ["name": "Travel", "lastMessage": "Hello", "lastActivity": Timestamp(date: Date())], id: "1")!]
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
    }
}
