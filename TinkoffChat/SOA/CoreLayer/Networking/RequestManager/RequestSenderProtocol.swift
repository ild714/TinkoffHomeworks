//
//  RequestSender.swift
//  TinkoffChat
//
//  Created by Ildar on 11/16/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badData
    case badEncoding
    case errorForRequest
    case badUrl
}

protocol RequestSenderProtocol {
    func send<Parser>(requestConfig: RequestConfig<Parser>, completion: @escaping(Result<Parser.Model, NetworkError>) -> Void)
}

struct RequestConfig<Parser> where Parser: ParserProtocol {
    let request: RequestProtocol
    let parser: Parser
}
