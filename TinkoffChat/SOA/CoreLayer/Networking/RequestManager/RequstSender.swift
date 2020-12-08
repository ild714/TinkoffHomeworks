//
//  RequstSender.swift
//  TinkoffChat
//
//  Created by Ildar on 11/16/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class RequestSender: RequestSenderProtocol {
    
    let session: URLSession?
    
    init(session: URLSession) {
        self.session = session
    }
    
    func send<Parser>(requestConfig: RequestConfig<Parser>, completion: @escaping (Result<Parser.Model, NetworkError>) -> Void) where Parser: ParserProtocol {
        
        guard let urlRequest = requestConfig.request.urlRequest else {
            completion(.failure(.badUrl))
            return
        }
        
        let task = session?.dataTask(with: urlRequest) { (data, _, error) in
            if error != nil {
                completion(.failure(.errorForRequest))
                return
            }
            guard let data = data, let parsedModel: Parser.Model = requestConfig.parser.parse(data: data) else {
                completion(.failure(.badData))
                return
            }
            completion(.success(parsedModel))
        }
        
        if let task = task {
            task.resume()
        } else {
            print("error with task")
        }
    }
    
}
