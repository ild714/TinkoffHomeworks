//
//  ImagesRequest.swift
//  TinkoffChat
//
//  Created by Ildar on 11/16/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

class ImagesRequest: RequestProtocol {
    
    private var url: String = "https://pixabay.com/api/?key=19137912-e4660b712cb718921308edb1e&q=yellow+flowers&image_type=photo&pretty=true&per_page=100"
    
    var urlRequest: URLRequest? {
        if let url = URL(string: url) {
            return URLRequest(url: url)
        }
        
        return nil
    }
}
