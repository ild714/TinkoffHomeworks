//
//  LogsSwitcher.swift
//  TinkoffChat
//
//  Created by Ildar on 9/16/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

class LogsSwitcher {
    static func switchState(_ dictionaryKey: String = "CompilerLogsOn",switchOn: Bool) -> Bool{
        
        var switchString: String = "False"
        
        if switchOn {
        } else {
            switchString = "True"
        }
        
        if Bundle.main.object(forInfoDictionaryKey: dictionaryKey) as? String == switchString {
            return true
        } else {
            return false
        }
    }
}
