//
//  ImageModel.swift
//  TinkoffChat
//
//  Created by Ildar on 11/17/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

struct ImageModel {
    let id: Int
    let previewURL: String
}

protocol ImageModelProtocol: class {
    func fetchImages()
}

protocol ImageModelDelegate: class {
    func setup(dataSource: [ImageModel])
    func show(error message: String)
}

class ImagesModel: ImageModelProtocol {
    weak var delegate: ImageModelDelegate?
    
    let imageService: ImageServiceProtocol
    
    init(imageService: ImageServiceProtocol) {
        self.imageService = imageService
    }
    
    func fetchImages() {
        imageService.loadImages(completion: { (result: Result<CodableParser.Model, NetworkError>) in
            switch result {
            case .success(let result):
                let data = result.hits.map { ImageModel(id: $0.id, previewURL: $0.previewURL) }
                self.delegate?.setup(dataSource: data)
            case .failure(let error):
                self.delegate?.show(error: error.localizedDescription)
            }
        })
    }
}
