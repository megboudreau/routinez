//
//  Entry.swift
//  routinez
//
//  Created by Megan Boudreau on 2017-12-16.
//  Copyright © 2017 Megan Boudreau. All rights reserved.
//

import Foundation
import CloudKit

func ==(lhs: Activity, rhs: Activity) -> Bool {
  return lhs.name == rhs.name &&
    lhs.entries == rhs.entries &&
    lhs.isBoolValue == rhs.isBoolValue
}

class Activity: Codable, Equatable {

  enum Unit: String {
    case noUnit = ""
    case grams = "g"
    case kilometres = "km"
  }

  var name: String
  var entries: [Entry] = [Entry]()
  var isBoolValue: Bool = false
  var unitOfMeasurement: String = Unit.noUnit.rawValue

  var dictValue: [String: Any] {
    return [
      "name": name,
      "isBoolValue": isBoolValue,
      "unitOfMeasurement": unitOfMeasurement]
  }

  private enum CodingKeys: String, CodingKey {
    case name, isBoolValue, unitOfMeasurement
  }

  init(name: String) {
    self.name = name
  }

  init(name: String, isBoolValue: Bool, unitOfMeasurement: String) {
    self.name = name
    self.isBoolValue = isBoolValue
    self.unitOfMeasurement = unitOfMeasurement
  }

  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try values.decode(String.self, forKey: .name)
    self.isBoolValue = try values.decode(Bool.self, forKey: .isBoolValue)
    self.unitOfMeasurement = try values.decode(String.self, forKey: .unitOfMeasurement)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(isBoolValue, forKey: .isBoolValue)
    try container.encode(unitOfMeasurement, forKey: .unitOfMeasurement)
  }
}

func ==(lhs: Entry, rhs: Entry) -> Bool {
  return lhs.value == rhs.value &&
    lhs.timestamp == rhs.timestamp
}

class Entry: Equatable, Codable {

  var timestamp: Date
  var value: Int

  var dictValue: [String: Any] {
    return ["timestamp": timestamp, "value": value]
  }

  private enum CodingKeys: String, CodingKey {
    case timestamp, value
  }

  init(timestamp: Date, value: Int) {
    self.timestamp = timestamp
    self.value = value
  }

  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.timestamp = try values.decode(Date.self, forKey: .timestamp)
    self.value = try values.decode(Int.self, forKey: .value)
  }
}
