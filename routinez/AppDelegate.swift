//
//  AppDelegate.swift
//  routinez
//
//  Created by Megan Boudreau on 2017-10-17.
//  Copyright © 2017 Megan Boudreau. All rights reserved.
//

import UIKit
import CloudKit
import WatchConnectivity

let NotificationEntryAddedOnPhone = "EntryAddedOnPhone"
let NotificationEntryAddedOnWatch = "EntryAddedOnWatch"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
//  var CKManager = CloudKitManager.sharedInstance()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    window.applyTheme()
    self.window?.makeKeyAndVisible()

    let navController = UINavigationController(rootViewController: MainTabBarController())
    window.rootViewController = navController

    setupWatchConnectivity()
    application.registerForRemoteNotifications()
    
    return true
  }

  // MARK: - CloudKit notifications
  // NOTE: remote notifications are not supported in the simulator
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("didRegisterForRemoteNotificationsWithDeviceToken \(deviceToken)")
  }

  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("didFailToRegisterForRemoteNotificationsWithError ERROR: \(error.localizedDescription)")
  }

  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

    // TO DO complete cloudkit stuff

//    let dict = userInfo as! [String: NSObject]
//    let notification = CKNotification(fromRemoteNotificationDictionary: dict)
//
//    if notification.subscriptionID == "private-changes" {
//      CKManager.fetchPrivateChanges {
//        completionHandler(UIBackgroundFetchResult.newData)
//      }
//    }
  }

}

extension AppDelegate: WCSessionDelegate {

  func sessionDidBecomeInactive(_ session: WCSession) {
  }

  func sessionDidDeactivate(_ session: WCSession) {
    WCSession.default.activate()
  }

  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    if let error = error {
      print("WC Session activation failed with error: \(error.localizedDescription)")
      return
    }
    print("WC Session activated with state: \(activationState.rawValue)")
  }

  static func sendEntryToWatch(successHandler: (() -> Void), errorHandler: @escaping (()-> Void)) {
    let session = WCSession.default

    // Here you want to get all the locally cached entries and send them over.
    let activitiesAndEntriesDict = Entries.sharedInstance.activitiesAndEntriesDict

    if WCSession.isSupported() {
      do {
        try session.updateApplicationContext(activitiesAndEntriesDict)
        successHandler()
      } catch let error {
        print(error.localizedDescription)
        errorHandler()
      }
    }
  }

  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    if let activities = applicationContext[watchConnectivityActivitiesKey] as? [String: Any],
      let entries = applicationContext[watchConnectivityEntriesKey] as? [String: Any] {

      for key in activities.keys {
        if let values = activities[key] as? [String: Any],
          let name = values["name"] as? String,
          let isBool = values["isBoolValue"] as? Bool,
          let unit = values["unitOfMeasurement"] as? String {
          let activity = Activity(name: name, isBoolValue: isBool, unitOfMeasurement: unit)
          Entries.sharedInstance.cacheNewActivity(activity)

          if entries.keys.contains(activity.name),
            let e = entries[key] as? [String: Any] {
            if let time = e["timestamp"] as? Date,
              let value = e["value"] as? Int {
              let newEntry = Entry(timestamp: time, value: value)
              Entries.sharedInstance.cacheNewEntry(newEntry, for: activity)
            }
          }
        }
      }

      DispatchQueue.main.async {
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(
          name: NSNotification.Name(rawValue: NotificationEntryAddedOnWatch), object: nil)
      }
    }
  }

  func setupWatchConnectivity() {
    if WCSession.isSupported() {
      let session = WCSession.default
      session.delegate = self
      session.activate()
    }
  }
}
