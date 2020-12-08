//
//  RootAssembly.swift
//  TinkoffChat
//
//  Created by Ildar on 11/11/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

class RootAssembly {
    lazy var presentationAssembly: PresentationAssembly = PresentationAssembly(serviceAssembly: self.serviceAssembly)
    private lazy var serviceAssembly: ServicesAssemblyProtocol = ServiceAssembly(coreAssembly: self.coreAssembly)
    private lazy var coreAssembly: CoreAssemblyProtocol = CoreAssembly()
}
