//
//  Extensions.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-23.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

extension Date {
  func isInSameWeek(date: Date) -> Bool {
    return Calendar.current.isDate(self, equalTo: date, toGranularity: .weekOfYear)
  }

  func isInSameMonth(date: Date) -> Bool {
    return Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
  }

  func isInSameYear(date: Date) -> Bool {
    return Calendar.current.isDate(self, equalTo: date, toGranularity: .year)
  }

  func isInSameDay(date: Date) -> Bool {
    return Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
  }

  var isInThisWeek: Bool {
    return isInSameWeek(date: Date())
  }

  var isInThisMonth: Bool {
    return isInSameMonth(date: Date())
  }

  var isInToday: Bool {
    return Calendar.current.isDateInToday(self)
  }

  var isInTheFuture: Bool {
    return Date() < self
  }

  var isInThePast: Bool {
    return self < Date()
  }
}

extension Int {
  var second: TimeInterval {
    return TimeInterval(self)
  }

  var seconds: TimeInterval {
    return TimeInterval(self)  }

  var minute: TimeInterval {
    return TimeInterval(self * 60)
  }

  var minutes: TimeInterval {
    return self.minute
  }

  var hour: TimeInterval {
    return TimeInterval(self * 60 * 60)
  }

  var hours: TimeInterval {
    return self.hour
  }

  var day: TimeInterval {
    return TimeInterval(self * 60 * 60 * 24)
  }

  var days: TimeInterval {
    return self.day
  }
}
