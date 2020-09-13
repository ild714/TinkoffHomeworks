//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Ildar on 9/12/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("Application moved from <Not running> to <Inactive>: \(#function)")
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("Application moved from <Inactive> -> <Active>: \(#function)")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("Application moved from <Active> -> <Inactive>: \(#function)")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Application moved from <Inactive> -> <Background>: \(#function)")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("Application moved from <Background> -> <Inactive>: \(#function)")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("Application moved from <Background> -> <Suspended> -> <Not running> or <Suspended> -> <Not running>: \(#function)")
    }

}

