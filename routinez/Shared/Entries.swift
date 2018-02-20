//
//  Entries.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-07.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import Foundation

enum EntryCacheKeys: String {
  case timestamp, value, name, isBoolValue
}

let defaultsEntryKey = "Entries"

class Entries {

  static let sharedInstance = Entries()

  private init() {}

//  var allEntries: [Entry] {
//    return [Entry]()
//
//
//    // TODO: check cache and return all the current entries saved to icloud
//  }

  var currentCachedEntries: [Entry]? {
    guard let currentEntriesArray = UserDefaults.standard.array(forKey: defaultsEntryKey) else {
      return nil
    }

    var cachedEntries: [Entry] = [Entry]()

    for cachedEntry in currentEntriesArray {
      if let cachedEntry = cachedEntry as? NSDictionary,
        let timestamp = cachedEntry["timestamp"] as? Date,
        let name = cachedEntry["name"] as? String,
        let value = cachedEntry["value"] as? Int,
        let isBoolValue = cachedEntry["isBoolValue"] as? Bool {
        let entry = Entry(name: name, timestamp: timestamp, value: value, isBoolValue: isBoolValue)
        cachedEntries.append(entry)
      }
    }

    return cachedEntries
  }

  var sortedEntriesByName: [String: [Entry]] {
    var sortedEntries: [String: [Entry]] = [:]

    if let currentCachedEntries = currentCachedEntries {
      for entry in currentCachedEntries {
        if !sortedEntries.keys.contains(entry.name) {
          sortedEntries[entry.name] = [entry]
        } else {
          sortedEntries[entry.name]?.append(entry)
        }
      }
    }

    return sortedEntries
  }

  var totalEntryCount: Int {
    return sortedEntriesByName.keys.count
  }

  var entriesDict: [String: Any] {
    var entriesArray: [[String: Any]] = []

    if let currentCachedEntries = currentCachedEntries {
      for entry in currentCachedEntries {
        entriesArray.append(entry.dictValue)
      }
    }

    return [defaultsEntryKey: entriesArray]
  }

  func entriesByName(name: String) -> [Entry] {
    guard let currentCachedEntries = currentCachedEntries else {
      return []
    }
    return currentCachedEntries.filter{ $0.name == name }
  }

  func totalDailyValueForEntry(_ name: String) -> Int {
    let calendar = Calendar.current
    let todaysEntries = entriesByName(name: name).filter {
      calendar.isDateInToday($0.timestamp)
    }

    return todaysEntries.map { $0.value }.reduce(0, +)
  }

  func cacheNewEntry(_ entry: Entry) {
    let defaults = UserDefaults.standard

    guard let currentCachedEntries = currentCachedEntries else {
      defaults.setValue([entry.dictValue], forKey: defaultsEntryKey)
      defaults.synchronize()
      return
    }

    if !currentCachedEntries.contains(entry) {

      var entriesDictArray = [[String: Any]]()
      entriesDictArray.append(entry.dictValue)
      for entry in currentCachedEntries {
        entriesDictArray.append(entry.dictValue)
      }

      defaults.setValue(entriesDictArray, forKey: defaultsEntryKey)
      defaults.synchronize()
    }

    let _ = defaults.array(forKey: defaultsEntryKey)
  }
}
