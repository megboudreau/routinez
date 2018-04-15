//
//  Entries.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-07.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit
import WatchConnectivity

enum EntryCacheKeys: String {
  case timestamp, value, name, isBoolValue
}

let watchConnectivityActivitiesKey = "Activities"
let watchConnectivityEntriesKey = "Entries"
let defaultsActivitiesKey = "Activities"

class Entries {

  static let sharedInstance = Entries()

  private init() {}

  var activityCount: Int {
    return cachedActivities?.count ?? 0
  }

  var defaultActivity: Activity? {
    // TODO let user choose default
    guard let activities = cachedActivities else {
      return nil
    }
    return activities.filter { $0.isDefault }.first
  }

  var cachedActivities: [Activity]? {
    let defaults = UserDefaults.standard
    if let data = defaults.value(forKey: defaultsActivitiesKey) as? Data {
      let activities = try? PropertyListDecoder().decode(Array<Activity>.self, from: data)
      return activities
    }

    return nil
  }

  var activityKeys: [String]? {
    guard let cachedActivities = cachedActivities else {
      return nil
    }
    return cachedActivities.map { $0.name }
  }

  func currentCachedEntries(for activity: Activity) -> [Entry]? {
    let key = activity.name
    let defaults = UserDefaults.standard

    if let data = defaults.value(forKey: key) as? Data {
      let entries = try? PropertyListDecoder().decode(Array<Entry>.self, from: data)
        return entries
    }

    return nil
  }

  func activityForName(_ name: String) -> Activity? {
    guard let cachedActivities = cachedActivities else {
      return nil
    }

    return cachedActivities.filter { $0.name == name }.first
  }

  func entriesForDay(_ activity: Activity) -> [Entry] {
    guard let currentCachedEntries = currentCachedEntries(for: activity) else {
      return [Entry]()
    }
    return currentCachedEntries.filter {
      Calendar.current.isDateInToday($0.timestamp)
    }
  }

  func entriesForWeek(_ activity: Activity) -> [Entry] {
    guard let currentCachedEntries = currentCachedEntries(for: activity) else {
      return [Entry]()
    }
    return currentCachedEntries.filter {
      $0.timestamp.isInThisWeek
    }
  }

  func entriesForMonth(_ activity: Activity) -> [Entry] {
    guard let currentCachedEntries = currentCachedEntries(for: activity) else {
      return [Entry]()
    }
    return currentCachedEntries.filter {
      $0.timestamp.isInThisMonth
    }
  }

  func totalDailyValue(for activity: Activity) -> Int {
    let todaysEntries = entriesForDay(activity)
    if activity.isBoolValue {
      return todaysEntries.last?.value ?? 0
    }
    return todaysEntries.map { $0.value }.reduce(0, +)
  }

  func stringTotalDailyValue(for activity: Activity) -> String {
    if activity.isBoolValue {
      return totalDailyValue(for: activity) == 1 ? "true" : "false"
    }

    let total = totalDailyValue(for: activity)
    return "\(total)\(activity.unitOfMeasurement.shortForm)"
  }

  func totalWeeklyValue(for activity: Activity) -> Int {
    let todaysEntries = entriesForWeek(activity)
    return todaysEntries.map { $0.value }.reduce(0, +)
  }

  func totalMonthlyValue(for activity: Activity) -> Int {
    let todaysEntries = entriesForMonth(activity)
    return todaysEntries.map { $0.value }.reduce(0, +)
  }

  func cacheEntries(_ entries: [Entry], for activity: Activity) {
    let defaults = UserDefaults.standard
    let encoder = PropertyListEncoder()
    let key = activity.name

    defaults.set(try? encoder.encode(entries), forKey: key)
    defaults.synchronize()
  }

  func cacheNewEntry(_ entry: Entry, for activity: Activity) {
    let defaults = UserDefaults.standard
    let encoder = PropertyListEncoder()
    let key = activity.name

    guard var currentCachedEntries = currentCachedEntries(for: activity) else {
      defaults.set(try? encoder.encode([entry]), forKey: key)
      defaults.synchronize()
      return
    }

    if !currentCachedEntries.contains(entry) {
      currentCachedEntries.append(entry)
      defaults.set(try? encoder.encode(currentCachedEntries), forKey: key)
      defaults.synchronize()
      syncWatch()
    }
  }

  func deleteActivityAndEntries(_ activity: Activity) {
    guard var cachedActivities = cachedActivities else {
      return
    }

    let defaults = UserDefaults.standard
    let encoder = PropertyListEncoder()

    defaults.removeObject(forKey: activity.name)

    if cachedActivities.contains(activity),
      let index = cachedActivities.index(of: activity) {
      cachedActivities.remove(at: index)

      defaults.set(try? encoder.encode(cachedActivities), forKey: defaultsActivitiesKey)
    }

    defaults.synchronize()
    syncWatch()
  }

  func cacheNewActivity(_ activity: Activity) {
    let defaults = UserDefaults.standard
    let encoder = PropertyListEncoder()

    guard var cachedActivities: [Activity] = cachedActivities else {
      defaults.set(try? encoder.encode([activity]), forKey: defaultsActivitiesKey)
      defaults.synchronize()
      syncWatch()
      return
    }

    if !cachedActivities.contains(activity) {
      if activity.isDefault {
        cachedActivities = cachedActivities.map { activity in
          activity.isDefault = false
          return activity
        }
      }

      cachedActivities.append(activity)

      defaults.set(try? encoder.encode(cachedActivities), forKey: defaultsActivitiesKey)
      defaults.synchronize()
      syncWatch()
    }
  }

  var activitiesAndEntriesDict: [String: Any] {
    guard let cachedActivities = cachedActivities else {
      return [watchConnectivityActivitiesKey: [],
              watchConnectivityEntriesKey: []]
    }

    var activityEntriesDict = [String: Any]()
    for activity in cachedActivities {
      if let entries = currentCachedEntries(for: activity) {
        var entriesDict = [[String:Any]]()
        for entry in entries {
          entriesDict.append(entry.dictValue)
        }
        activityEntriesDict[activity.name] = entriesDict
      }
    }

    var activitiesDict = [[String: Any]]()
    for activity in cachedActivities {
      activitiesDict.append(activity.dictValue)
    }

    return [watchConnectivityActivitiesKey: activitiesDict,
            watchConnectivityEntriesKey: activityEntriesDict]
  }

  func syncWatch() {
    #if os(iOS)
      NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationEntryAddedOnPhone), object: nil)
    #endif
  }

}
