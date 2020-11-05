//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Ildar on 9/12/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coreData = ModernCoreDataStack()
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        LogsSwitcher.switchState(switchOn: false)
        LogsSwitcher.printLogs(function: #function, additionText: "Application is not <Not running>: ")
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LogsSwitcher.printLogs(function: #function, additionText: "Application moved from <Not running> to <Inactive>: ")
        
        FirebaseApp.configure()

//        self.coreData.container.per
        
        RootViewController.createRootViewController(window: window)
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        LogsSwitcher.printLogs(function: #function, additionText: "Application moved from <Inactive> -> <Active>: ")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        LogsSwitcher.printLogs(function: #function, additionText: "Application moved from <Active> -> <Inactive>: ")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        LogsSwitcher.printLogs(function: #function, additionText: "Application moved from <Inactive> -> <Background>: ")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        LogsSwitcher.printLogs(function: #function, additionText: "Application moved from <Background> -> <Inactive>: ")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        LogsSwitcher.printLogs(function: #function, additionText: "Application moved from <Background> -> <Suspended> -> <Not running> or <Suspended> -> <Not running>: ")
    }

}

extension AppDelegate {
    static var shared: AppDelegate? {
        if let result = UIApplication.shared.delegate as? AppDelegate {
            return result
        } else {
            print("Error with AppDelegate")
            return nil
        }
    }
}
