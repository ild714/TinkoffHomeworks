//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Ildar on 9/12/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is not visible: ")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is not visible: ")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is not visible: ")
    }
    
    override func viewWillLayoutSubviews() {
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is not visible: ")
    }
    
    override func viewDidLayoutSubviews() {
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is visible: ")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is visible: ")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is not visible: ")
    }
}

