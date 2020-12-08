//
//  ImageService.swift
//  TinkoffChat
//
//  Created by Ildar on 11/16/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol ImageServiceProtocol {
    func loadImages(completion: @escaping (Result<CodableParser.Model, NetworkError>) -> Void)
}

class ImageService: ImageServiceProtocol {
    let requestSender: RequestSenderProtocol
    
    init(requestSender: RequestSenderProtocol) {
        self.requestSender = requestSender
    }
    
    func loadImages(completion: @escaping (Result<CodableParser.Model, NetworkError>) -> Void) {
        
        let requestConfig = RequestCreator.newImageConfig()
        load(requestConfig: RequestConfig(request: requestConfig.request, parser: requestConfig.parser), completion: completion)
    }
    
    private func load(requestConfig: RequestConfig<CodableParser>, completion: @escaping (Result<CodableParser.Model, NetworkError>) -> Void) {
        requestSender.send(requestConfig: requestConfig) { (result: Result<CodableParser.Model, NetworkError>) in
            
            completion(result)
        }
    }
}
