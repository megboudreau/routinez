//
//  Entry.swift
//  routinez
//
//  Created by Megan Boudreau on 2017-12-16.
//  Copyright © 2017 Megan Boudreau. All rights reserved.
//

import UIKit
import CloudKit

func ==(lhs: Activity, rhs: Activity) -> Bool {
  return lhs.name == rhs.name &&
    lhs.entries == rhs.entries &&
    lhs.isBoolValue == rhs.isBoolValue
}

class Activity: Codable, Equatable {

  var colorIndex: Int
  var name: String
  var entries: [Entry] = [Entry]()
  var isBoolValue: Bool = false
  var isDefault: Bool = false
  var unitOfMeasurement: Unit = .noUnit

  var color: UIColor {
    return UIColor.activityColors[colorIndex]
  }

  static var emptyActivity: Activity {
    return Activity(colorIndex: -1, name: "")
  }

  var dictValue: [String: Any] {
    return [
      "colorIndex": colorIndex,
      "name": name,
      "isBoolValue": isBoolValue,
      "isDefault": isDefault,
      "unitOfMeasurement": unitOfMeasurement.rawValue]
  }

  private enum CodingKeys: String, CodingKey {
    case colorIndex, name, isBoolValue, unitOfMeasurement, isDefault
  }

  init(colorIndex: Int, name: String) {
    self.colorIndex = colorIndex
    self.name = name
  }

  init(colorIndex: Int, name: String, isBoolValue: Bool, unitOfMeasurement: Unit, isDefault: Bool) {
    self.colorIndex = colorIndex
    self.name = name
    self.isBoolValue = isBoolValue
    self.isDefault = isDefault
    self.unitOfMeasurement = unitOfMeasurement
  }

  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.colorIndex = try values.decode(Int.self, forKey: .colorIndex)
    self.name = try values.decode(String.self, forKey: .name)
    self.isBoolValue = try values.decode(Bool.self, forKey: .isBoolValue)
    self.isDefault = try values.decode(Bool.self, forKey: .isDefault)
    let unitString = try values.decode(String.self, forKey: .unitOfMeasurement)
    self.unitOfMeasurement = Unit.unitFromString(unitString)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(colorIndex, forKey: .colorIndex)
    try container.encode(isBoolValue, forKey: .isBoolValue)
    try container.encode(isDefault, forKey: .isDefault)
    try container.encode(unitOfMeasurement.rawValue, forKey: .unitOfMeasurement)
  }
}

enum Unit: String {
  case noUnit = "no unit"
  case grams = "grams"
  case milligrams = "milligrams"
  case kilograms = "kilograms"
  case kilometres = "kilometres"
  case millilitres = "millilitres"
  case litres = "litres"
  case miles = "miles"
  case metres = "metres"
  case ounces = "ounces"
  case pounds = "pounds"

  static func unitFromString(_ string: String) -> Unit{
    return allUnits.filter{ $0.rawValue == string }.first ?? .noUnit
  }

  var shortForm: String {
    switch self {
    case .grams:
      return "g"
    case .milligrams:
      return "mg"
    case .kilograms:
      return "kg"
    case .millilitres:
      return "mL"
    case .litres:
      return "L"
    case .miles:
      return "mi"
    case .ounces:
      return "oz"
    case .pounds:
      return "lb"
    case .metres:
      return "m"
    case .kilometres:
      return "km"
    default:
      return ""
    }
  }

  static let allUnits: [Unit] = [.noUnit, .pounds, .milligrams, .grams, .kilograms, .miles, .kilometres, .metres, .millilitres, .litres, .ounces]
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
