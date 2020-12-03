//
//  RootAssemblyMock.swift
//  TinkoffChatTests
//
//  Created by Ildar on 12/3/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
@testable import TinkoffChat

class RootAssemblyMock {
    lazy var presentationAssembly: PresentationAssembly = PresentationAssembly(serviceAssembly: self.serviceAssembly)
    private lazy var serviceAssembly: ServicesAssemblyProtocol = ServiceAssembly(coreAssembly: self.coreAssembly)
    lazy var coreAssembly: CoreAssemblyProtocol = CoreAssemblyMock()
}
