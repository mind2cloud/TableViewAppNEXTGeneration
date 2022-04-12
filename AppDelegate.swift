//
//  AppDelegate.swift
//  TableViewAppNEXTGeneration
//
//  Created by Roman Kochnev on 31.01.2018.
//  Copyright © 2018 Roman Kochnev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Цвет самого Navigation Bar'а
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.09468112141, green: 0.4992194176, blue: 0.4842631221, alpha: 1)
        // Цвет элементов перехода Navigation Bar'а
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        //UITabBar.appearance().tintColor = UIColor.white
        //UITabBar.appearance().barTintColor = #colorLiteral(red: 0.09468112141, green: 0.4992194176, blue: 0.4842631221, alpha: 1)
        
        // Добавляем следующие атрибуты тексту: цвет и шрифт с размером, организуя коллекцию "словарь"
        if let barFont = UIFont(name: " ", size: 25) {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: barFont]
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.coreDataStack.saveContext()
    }
}

