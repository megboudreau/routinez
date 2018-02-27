//
//  Entry.swift
//  routinez
//
//  Created by Megan Boudreau on 2017-12-16.
//  Copyright © 2017 Megan Boudreau. All rights reserved.
//

import Foundation
import CloudKit

func ==(lhs: Entry, rhs: Entry) -> Bool {
  return lhs.name == rhs.name &&
    lhs.value == rhs.value &&
    lhs.timestamp == rhs.timestamp &&
    lhs.isBoolValue == rhs.isBoolValue
}

//TODO:
// Entry with name, isBoolValue, unitOfMeasurement, values: EntryValues
// ENtryValues: timestamp, value

class Entry: Equatable {

  var name: String = "Calories"
  var timestamp: Date
  var value: Int
  var isBoolValue: Bool = false //consider changing this to enum ValueType
  // var unitOfMeasurement consider for future

  var dictValue: [String: Any] {
    return [ "name": name,
             "timestamp": timestamp,
             "value": value,
             "isBoolValue": isBoolValue
            ]
  }

  init(name: String, timestamp: Date, value: Int, isBoolValue: Bool = false) {
    self.name = name
    self.timestamp = timestamp
    self.value = value
    self.isBoolValue = isBoolValue
  }
}

//  private enum CodingKeys: String, CodingKey {
//    case timestamp, value, name, isBoolValue
//  }
//  init(from decoder: Decoder) throws {
//    let values = try decoder.container(keyedBy: CodingKeys.self)
//    timestamp = try values.decode(Date.self, forKey: .timestamp)
//    value = try values.decode(Int.self, forKey: .value)
//    name = try values.decode(String.self, forKey: .name)
//    isBoolValue = try values.decode(Bool.self, forKey: .isBoolValue)
//  }
//
//  func encode(to encoder: Encoder) throws {
//    var container = encoder.container(keyedBy: CodingKeys.self)
//    try container.encode(timestamp, forKey: .timestamp)
//    try container.encode(value, forKey: .value)
//    try container.encode(name, forKey: .name)
//    try container.encode(isBoolValue, forKey: .isBoolValue)
//  }

