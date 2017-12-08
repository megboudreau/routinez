//
//  DefaultsManager.swift
//  routinez
//
//  Created by Megan Boudreau on 2017-11-13.
//  Copyright © 2017 Megan Boudreau. All rights reserved.
//

import Foundation

class DefaultsManager {

  static func addCalories(_ calories: Int) {
    let currentTotal = DefaultsManager.dailyTotal
    DefaultsManager.dailyTotal = currentTotal + calories

    let currentWeeklyTotal = DefaultsManager.weeklyTotal
    DefaultsManager.weeklyTotal = currentWeeklyTotal + calories
  }

  static var currentDay: Date {
    get {
      let dateString = UserDefaults.standard.string(forKey: "currentDay")!
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      return dateFormatter.date(from: dateString)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "currentDay")
    }
  }

  static var dailyTotal: Int {
    get {
      return UserDefaults.standard.integer(forKey: "dailyTotal")
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "dailyTotal")
    }
  }

  static var weeklyTotal: Int {
    get {
      return UserDefaults.standard.integer(forKey: "weeklyTotal")
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "weeklyTotal")
    }
  }
}
