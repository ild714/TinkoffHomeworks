//
//  CodableParser.swift
//  TinkoffChat
//
//  Created by Ildar on 11/16/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

struct ApiModel: Codable {
    var total: Int
    var totalHits: Int
    var hits: [Image]
}

struct Image: Codable {
    let id: Int
    let previewURL: String
}

class CodableParser: ParserProtocol {
    typealias Model = ApiModel
    
    func parse(data: Data) -> ApiModel? {
        let decoder = JSONDecoder()
        
        do {
            let decoded = try decoder.decode(ApiModel.self, from: data)
            print(decoded)
            return decoded
        } catch {
            print("Failed to decode JSON")
        }
        return nil
    }
}
