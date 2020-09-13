//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Ildar on 9/12/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if Bundle.main.object(forInfoDictionaryKey: "CompilerLogsOn") as! String == "False"{
        } else {
            print(#function)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Bundle.main.object(forInfoDictionaryKey: "CompilerLogsOn") as! String == "False"{
        } else {
            print(#function)
        }
    }
    
    override func viewWillLayoutSubviews() {
        if Bundle.main.object(forInfoDictionaryKey: "CompilerLogsOn") as! String == "False"{
        } else {
            print(#function)
        }
    }
    
    override func viewDidLayoutSubviews() {
        if Bundle.main.object(forInfoDictionaryKey: "CompilerLogsOn") as! String == "False"{
        } else {
            print(#function)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if Bundle.main.object(forInfoDictionaryKey: "CompilerLogsOn") as! String == "False"{
        } else {
            print(#function)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if Bundle.main.object(forInfoDictionaryKey: "CompilerLogsOn") as! String == "False"{
        } else {
            print(#function)
        }
    }


}

