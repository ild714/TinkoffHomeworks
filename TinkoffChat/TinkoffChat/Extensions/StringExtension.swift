//
//  StringExtension.swift
//  TinkoffChat
//
//  Created by Ildar on 9/23/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation


extension String {
    func initialsGetter() -> String{
            let formatter = PersonNameComponentsFormatter()
            
            if let components = formatter.personNameComponents(from: self){
                formatter.style = .abbreviated
                return formatter.string(from: components)
            } else {
             return ""
         }
    }
}
