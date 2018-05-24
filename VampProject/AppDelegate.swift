//
//  AppDelegate.swift
//  VampProject
//
//  Created by Gusto Nemec on 16/03/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import EstimoteProximitySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    
    var window: UIWindow?
    var proximityObserver: EPXProximityObserver!
    var manager = TimeTableDataManager.shared
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        manager.makeGetCall { (_) in
        }
        
        
        let cloudCredentials = EPXCloudCredentials(appID: "vampproject-k92",
                                                   appToken: "a9108116916562a1956beffbb6280d83")
        
        self.proximityObserver = EPXProximityObserver(
            credentials: cloudCredentials,
            errorBlock: { error in
                print("proximity observer error: \(error)")
        })
        
        let zone1 = EPXProximityZone(range: .near,
                                     attachmentKey: "location", attachmentValue: "mu")
        zone1.onEnterAction = { attachment in
            print("NOTIFICATION")
            self.sendNotification(code: attachment.payload["room"] as! String)
        }
        zone1.onExitAction = { attachment in
            print("EXIT")
        }
        
        
        self.proximityObserver.startObserving([zone1])
        
        
        let center = UNUserNotificationCenter.current()
        //center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in }
        center.delegate = self
        
        let ac1 = setAction(id: "openMaterials", title: "Open Materials")
        //let ac2 = setAction(id: "share", title: "Share")
        let cat1 = setCategory(identifier: "category", action: [ac1], intentIdentifiers: [])
        center.setNotificationCategories([cat1])
        
        center.requestAuthorization(options: [.badge, .alert , .sound]) { (success, error) in }
        
        return true
    }
    
    func sendNotification(code : String) {
        let subject = findSubject(inRoom: code)
        if subject == nil {
            print("Nothing in the room!")
            return
        } else {
            let content = UNMutableNotificationContent()
            content.title = (subject?.code)! + " in room " + code
            content.body = (subject?.name)!
            content.sound = .default()
            content.categoryIdentifier = "category"
            
            let request = UNNotificationRequest(identifier: (subject?.code)!, content: content, trigger: nil)
            DispatchQueue.main.async {
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
    }
    
    func findSubject(inRoom: String) -> Subject? {
        
        let date = Date()
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: date) - 2
        let hour = myCalendar.component(.hour, from: date)
        for room in manager.rooms {
            if room.name == inRoom {
                for day in room.days {
                    if day.nameIndex == weekDay {
                        for subject in day.subjects {
                            if hour >= subject.time && hour < subject.time + 2 {
                                return subject
                            }
                        }
                    }
                }
            }
        }
        
        return nil
    }
    
    
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        
        completionHandler([.alert, .badge, .sound])
    }
    
    private func setAction(id: String, title: String, options: UNNotificationActionOptions = [.foreground]) -> UNNotificationAction {
        
        let action = UNNotificationAction(identifier: id, title: title, options: options)
        
        return action
    }
    
    private func setCategory(identifier: String, action:[UNNotificationAction],  intentIdentifiers: [String], options: UNNotificationCategoryOptions = []) -> UNNotificationCategory {
        
        let category = UNNotificationCategory(identifier: identifier, actions: action, intentIdentifiers: intentIdentifiers, options: options)
        
        return category
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let actionIdentifier = response.actionIdentifier
        //let content = response.notification.request.content
        
        switch actionIdentifier {
        case UNNotificationDismissActionIdentifier: // Notification was dismissed by user
            // Do something
            completionHandler()
        case UNNotificationDefaultActionIdentifier: // App was opened from notification
            // Do something
            //openWebsite()
            completionHandler()
            
        case "openMaterials":
            openWebsite(code: response.notification.request.identifier)
            completionHandler()
        default:
            completionHandler()
        }
    }
    
    func openWebsite(code: String) {
        
        UIApplication.shared.open(URL(string : "https://is.muni.cz/auth/el/1433/jaro2018/" + code)!, options: [:], completionHandler: { (status) in
            
        })
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
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "VampProject")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

