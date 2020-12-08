//
//  RequestCreator.swift
//  TinkoffChat
//
//  Created by Ildar on 11/16/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

struct RequestCreator {
    static func newImageConfig() -> RequestConfig<CodableParser> {
        return RequestConfig<CodableParser>(request: ImagesRequest(), parser: CodableParser())
    }
}
