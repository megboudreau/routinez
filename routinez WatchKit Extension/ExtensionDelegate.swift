//
//  ExtensionDelegate.swift
//  routinez WatchKit Extension
//
//  Created by Megan Boudreau on 2017-10-17.
//  Copyright © 2017 Megan Boudreau. All rights reserved.
//

import WatchKit
import WatchConnectivity

let NotificationEntryOnWatch = "EntryOnWatch"

class ExtensionDelegate: NSObject, WKExtensionDelegate {

  lazy var notificationCenter: NotificationCenter = {
    return NotificationCenter.default
  }()

  func handleUserActivity(
    _ userInfo: [AnyHashable : Any]?) {
    if let date = userInfo?[CLKLaunchedTimelineEntryDateKey]
      as? Date {
      print("launched from complication with date:\(date)")
    }
  }

  func applicationDidFinishLaunching() {
    setupWatchConnectivity()
  }

  func applicationDidBecomeActive() {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillResignActive() {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, etc.
  }

  func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
    // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
    for task in backgroundTasks {
      // Use a switch statement to check the task type
      switch task {
      case let backgroundTask as WKApplicationRefreshBackgroundTask:
        // Be sure to complete the background task once you’re done.
        backgroundTask.setTaskCompletedWithSnapshot(false)
      case let snapshotTask as WKSnapshotRefreshBackgroundTask:
        // Snapshot tasks have a unique completion call, make sure to set your expiration date
        snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
      case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
        // Be sure to complete the connectivity task once you’re done.
        connectivityTask.setTaskCompletedWithSnapshot(false)
      case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
        // Be sure to complete the URL session task once you’re done.
        urlSessionTask.setTaskCompletedWithSnapshot(false)
      default:
        // make sure to complete unhandled task types
        task.setTaskCompletedWithSnapshot(false)
      }
    }
  }
}

extension ExtensionDelegate: WCSessionDelegate {

  func setupWatchConnectivity() {
    if WCSession.isSupported() {
      let session = WCSession.default
      session.delegate = self
      session.activate()
    }
  }

  // this might need to be updated at some point to userInfo to send multiple entries
  static func sendEntryToPhone(successHandler: (() -> Void), errorHandler: @escaping (()-> Void)) {

    // Here you want to get all the locally cached entries and send them over.
    let entriesDict = Entries.sharedInstance.activitiesAndEntriesDict

    if WCSession.isSupported() {
      do {
        try WCSession.default.updateApplicationContext(entriesDict)
        ExtensionDelegate.reloadComplications()
        successHandler()
      } catch let error {
        print(error.localizedDescription)
        errorHandler()
      }
    }
  }

  static func reloadComplications() {
    let server = CLKComplicationServer.sharedInstance()
    guard let complications = server.activeComplications,
      complications.count > 0 else {
        return
    }

    for complication in complications  {
      server.reloadTimeline(for: complication)
    }
  }

  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    print("didReceiveApplicationContext")

    if let activities = applicationContext[watchConnectivityActivitiesKey] as? [[String: Any]],
      let entries = applicationContext[watchConnectivityEntriesKey] as? [String: Any] {


      var newActivities = [Activity]()
      for activityDict in activities {
        if let name = activityDict["name"] as? String,
          let isBool = activityDict["isBoolValue"] as? Bool,
          let isDefault = activityDict["isDefault"] as? Bool,
          let colorIndex = activityDict["colorIndex"] as? Int,
          let range = activityDict["range"] as? Int,
          let unit = activityDict["unitOfMeasurement"] as? String {
          let activity = Activity(range: range, colorIndex: colorIndex, name: name, isBoolValue: isBool, unitOfMeasurement: Unit.unitFromString(unit), isDefault: isDefault)
          newActivities.append(activity)
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

      if let oldActivities = Entries.sharedInstance.cachedActivities {
        let deletedActivities = oldActivities.filter { !newActivities.contains($0) }
        deletedActivities.forEach { activity in
          Entries.sharedInstance.deleteActivityAndEntries(activity)
        }
      }
      ExtensionDelegate.reloadComplications()
      reloadRootController()
    }
  }

  func reloadRootController() {
    DispatchQueue.main.async {
      WKInterfaceController.reloadRootPageControllers(withNames: ["ActivitiesList"],
                                                      contexts: nil,
                                                      orientation: WKPageOrientation.vertical,
                                                      pageIndex: 0)
    }

  }

  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    print("activationDidCompleteWith")
  }
}
