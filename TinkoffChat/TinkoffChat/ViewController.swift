//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Ildar on 9/12/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var switchState = LogsSwitcher.switchState(switchOn: true)
    
    override func viewDidLoad() {
        if switchState{
        } else {
            print("Root view is not visible: \(#function)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if switchState{
        } else {
            print("Root view is not visible: \(#function)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if switchState{
        } else {
            print("Root view is not visible: \(#function)")
        }
    }
    
    override func viewWillLayoutSubviews() {
        if switchState{
        } else {
            print("Root view is not visible: \(#function)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        if switchState{
        } else {
            print("Root view is visible: \(#function)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if switchState{
        } else {
            print("Root view is visible: \(#function)")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if switchState{
        } else {
            print("Root view is not visible: \(#function)")
        }
    }
}

