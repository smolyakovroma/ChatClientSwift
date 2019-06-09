//
//  AppDelegate.swift
//  ChatClient
//
//  Created by Роман Смоляков on 31/05/2019.
//  Copyright © 2019 Роман Смоляков. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Constants.dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        Constants.dateFormatter.locale = NSLocale.current
//        Constants.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
          Constants.dateFormatter.dateFormat = "HH:mm"
        let realm = try! Realm()
//        if let id = realm.objects(User.self).first?.id {
//
//        }
        SocketHelper.sharedInstance.socket.on(clientEvent: .connect, callback: { (data, ack) in
            print("--- onConnect contacts---")
            if !Constants.id.isEmpty {
                SocketHelper.sharedInstance.subscribe(id: Constants.id)
            }
        })
        
       
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //        print("applicationDidEnterBackground")
        SocketHelper.sharedInstance.closeConnection()
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //      print("applicationDidBecomeActive")
        print("establishConnection")
        SocketHelper.sharedInstance.establishConnection()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

