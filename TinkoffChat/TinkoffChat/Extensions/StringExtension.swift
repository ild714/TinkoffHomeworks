//
//  StringExtension.swift
//  TinkoffChat
//
//  Created by Ildar on 9/23/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    func initialsGetter() -> String {
        if let text = self {
            
            let formatter = PersonNameComponentsFormatter()
            
            if let components = formatter.personNameComponents(from: text) {
                formatter.style = .abbreviated
                return formatter.string(from: components)
            } else {
             return ""
         }
            
        } else {
            return ""
        }
    }
}
