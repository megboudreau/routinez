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
  lazy var notificationCenter: NotificationCenter = {
    return NotificationCenter.default
  }()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    window.applyTheme()
    self.window?.makeKeyAndVisible()

    let navController = UINavigationController(rootViewController: MainTabBarController())
    window.rootViewController = navController

    setupWatchConnectivity()
    setupNotificationCenter()
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

  private func setupNotificationCenter() {
    notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NotificationEntryAddedOnPhone), object: nil, queue: nil) { (notification:Notification) -> Void in
      self.sendEntryToWatch(successHandler: {
        print("successfully sent to watch")
      }, errorHandler: {
        print("error sending to watch")
      })
    }
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

  func sendEntryToWatch(successHandler: (() -> Void)? = nil, errorHandler: (()-> Void)? = nil) {
    let session = WCSession.default

    // Here you want to get all the locally cached entries and send them over.
    let activitiesAndEntriesDict = Entries.sharedInstance.activitiesAndEntriesDict

    if WCSession.isSupported() {
      do {
        try session.updateApplicationContext(activitiesAndEntriesDict)
        successHandler?()
      } catch let error {
        print(error.localizedDescription)
        errorHandler?()
      }
    }
  }

  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    if let activities = applicationContext[watchConnectivityActivitiesKey] as? [[String: Any]],
      let entries = applicationContext[watchConnectivityEntriesKey] as? [String: Any] {

      for activityDict in activities {
        if let name = activityDict["name"] as? String,
          let isBool = activityDict["isBoolValue"] as? Bool,
          let unit = activityDict["unitOfMeasurement"] as? String {
          let activity = Activity(name: name, isBoolValue: isBool, unitOfMeasurement: Unit.unitFromString(unit))
          Entries.sharedInstance.cacheNewActivity(activity)

          if entries.keys.contains(activity.name),
            let activityEntries = entries[activity.name] as? [[String: Any]] {
            var newEntries = [Entry]()
            for entry in activityEntries {
              if let time = entry["timestamp"] as? Date,
                let value = entry["value"] as? Int {
                let newEntry = Entry(timestamp: time, value: value)
                newEntries.append(newEntry)
              }
            }
            Entries.sharedInstance.cacheEntries(newEntries, for: activity)
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
