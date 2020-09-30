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
    var navigationController: UINavigationController = UINavigationController()
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        LogsSwitcher.switchState(switchOn: false)
        LogsSwitcher.printLogs(function: #function, additionText: "Application is not <Not running>: ")
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LogsSwitcher.printLogs(function: #function, additionText: "Application moved from <Not running> to <Inactive>: ")
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if let conversationsListViewController = ConversationsListViewController.storyboardInstance(){
            
            let storyboard: UIStoryboard = UIStoryboard(name: "ConversationsListViewController", bundle: nil)
            
            if let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController{
                
                navigationController.viewControllers = [conversationsListViewController]
                self.window?.rootViewController = navigationController
                self.window?.makeKeyAndVisible()
            }
        }
        
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

