//
//  ParserProtocol.swift
//  TinkoffChat
//
//  Created by Ildar on 11/16/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol ParserProtocol {
    associatedtype Model
    func parse(data: Data) -> Model?
}
