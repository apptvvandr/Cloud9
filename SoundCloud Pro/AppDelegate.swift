//
//  AppDelegate.swift
//  SoundCloud Pro
//
//  Created by Austin Feight on 6/30/15.
//  Copyright (c) 2015 Lost in Flight. All rights reserved.
//

import UIKit
import CoreData

let kSoundCloudClientID = "823363d3a8c33bfb0a1c608da13141b2"
let kSoundCloudClientSecret = "ad456d110c3c4a8f7ac9dacfb2f3c6c6"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
  {    
    SCSoundCloud.setClientID(kSoundCloudClientID, secret: kSoundCloudClientSecret, redirectURL: NSURL(string: "SoundCloudPro://OAuth"))
    return true
  }
}

// MARK: - URL Handling
extension AppDelegate {
  func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool
  {
    NSLog("opening url: \(url)")
    SCSoundCloud.handleRedirectURL(url)
    print("penis")
    return true
  }
  
  func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool
  {
    NSLog("opening url: \(url)")
    SCSoundCloud.handleRedirectURL(url)
    return true
  }
}


extension AppDelegate {
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    // self.saveContext()
  }
  
  // MARK: - Core Data stack
  
//  lazy var applicationDocumentsDirectory: NSURL = {
//    // The directory the application uses to store the Core Data store file.
//    // This code uses a directory named "com.LostInFlight.SoundCloud_Pro"
//    // in the application's documents Application Support directory.
//    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//    return urls[urls.count - 1] as NSURL
//    }()
//  
//  lazy var managedObjectModel: NSManagedObjectModel = {
//    // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
//    let modelURL = NSBundle.mainBundle().URLForResource("SoundCloud_Pro", withExtension: "momd")!
//    return NSManagedObjectModel(contentsOfURL: modelURL)!
//    }()
//  
//  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
//    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
//    // Create the coordinator and store
//    var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
//    let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SoundCloud_Pro.sqlite")
//    var error: NSError? = nil
//    var failureReason = "There was an error creating or loading the application's saved data."
//    
//    if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil) == nil {
//      coordinator = nil
//      // Report any error we got.
//      var dict = [String: AnyObject]()
//      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
//      dict[NSLocalizedFailureReasonErrorKey] = failureReason
//      dict[NSUnderlyingErrorKey] = error
//      error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
//      // Replace this with code to handle the error appropriately.
//      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//      NSLog("Unresolved error \(error), \(error!.userInfo)")
//      abort()
//    }
//    
//    return coordinator
//    }()
//  
//  lazy var managedObjectContext: NSManagedObjectContext? = {
//    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
//    let coordinator = self.persistentStoreCoordinator
//    if coordinator == nil {
//      return nil
//    }
//    var managedObjectContext = NSManagedObjectContext()
//    managedObjectContext.persistentStoreCoordinator = coordinator
//    return managedObjectContext
//    }()
//  
//  // MARK: - Core Data Saving support
//  
//  func saveContext () {
//    if let moc = self.managedObjectContext {
//      var error: NSError? = nil
//      if moc.hasChanges && !moc.save(&error) {
//        // Replace this implementation with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog("Unresolved error \(error), \(error!.userInfo)")
//        abort()
//      }
//    }
//  }
}
