//
//  LogsSwitcher.swift
//  TinkoffChat
//
//  Created by Ildar on 9/16/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

class LogsSwitcher {
    
    static var state = true
    
    static func switchState(switchOn: Bool){
        self.state = switchOn
    }
    
    static func printLogs(function:String, additionText: String = ""){
        if state == true {
            print("\(additionText)\(function)")
        }
    }
}
