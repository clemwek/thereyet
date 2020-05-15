//
//  AppDelegate.swift
//  thereYet
//
//  Created by Clement Wekesa on 28/03/2020.
//  Copyright © 2020 ddhwty. All rights reserved.
//

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import CoreData
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // Create a notification center handler
    let center = UNUserNotificationCenter.current()
    
    //MARK: Core data setup
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "thereYet")
        container.loadPersistentStores (completionHandler: { (storeDescription, error) in
            print(storeDescription)
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        MSAppCenter.start("5479b77b-0f09-44ef-bf7e-4d5ea94d5cea", withServices:[
            MSAnalytics.self,
            MSCrashes.self
        ])
        
        // Request for permision to show notifications
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print ("permision was: ", granted)
        }
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo

        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")
                
            case "show":
                // the user tapped our "show more info…" button
                print("Show more information…")
                break
                
            default:
                break
            }
        }
        // you must call the completion handler when you're done
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("--------->>>>>>> some how we are getting here.")
    }
}
