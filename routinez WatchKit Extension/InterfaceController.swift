//
//  InterfaceController.swift
//  routinez WatchKit Extension
//
//  Created by Megan Boudreau on 2017-10-17.
//  Copyright © 2017 Megan Boudreau. All rights reserved.
//

import WatchKit
import WatchConnectivity
import ClockKit

class InterfaceController: WKInterfaceController {

  @IBOutlet var entryValuesPicker: WKInterfacePicker!
  @IBOutlet var dailyTotalLabel: WKInterfaceLabel!
  @IBOutlet var addButton: WKInterfaceButton!

  var selectedItem: Int = 0
  var selectedBool: Bool = false
  var activity: Activity?

//  let ckManager = CloudKitManager.sharedInstance()

  override func awake(withContext context: Any?) {
    super.awake(withContext: context)

    if let activity = context as? Activity {
      self.activity = activity
    }
  }

  override func willActivate() {
    super.willActivate()

    guard let activity = activity else {
      return
    }

    var pickerItems: [WKPickerItem]
    if activity.isBoolValue {
      let trueItem = WKPickerItem()
      trueItem.caption = activity.name
      trueItem.title = "True"

      let falseItem = WKPickerItem()
      falseItem.caption = activity.name
      falseItem.title = "False"

      pickerItems = [trueItem, falseItem]
    } else {
      let entryValues = stride(from:0, to: 2500, by: 1)
      pickerItems = entryValues.map {
        let pickerItem = WKPickerItem()
        pickerItem.title = "\($0)"
        pickerItem.caption = activity.name
        return pickerItem
      }
    }

    entryValuesPicker.setItems(pickerItems)

    updateDisplay()
  }

  override func didDeactivate() {
    ExtensionDelegate.reloadComplications()
    super.didDeactivate()
  }

  func updateDisplay() {
    guard let activity = activity else {
      return
    }

    let currentDailyTotal = Entries.sharedInstance.totalDailyValue(for: activity)
    updateDailyTotalLabel(with: currentDailyTotal)
  }

  @IBAction func didTapAddButton() {
    guard let activity = activity else {
      return
    }

    var value: Int = selectedItem
    if activity.isBoolValue {
      value = selectedBool == true ? 1 : 0
    }
    let entry = Entry(timestamp: Date(), value: value)
    Entries.sharedInstance.cacheNewEntry(entry, for: activity)

    addButton.setTitle("Sending...")
    ExtensionDelegate.sendEntryToPhone(
      successHandler: setSuccessTitle,
      errorHandler: setErrorTitle
    )
  }

  @IBAction func pickerSelectedItemChanged(_ value: Int) {
    guard let activity = activity,
      !activity.isBoolValue else {
        selectedBool = value == 0 ? false : true
        return
    }
    selectedItem = value
  }

  func setErrorTitle() {
    addButton.setTitle("Try again")
    delay(1) {
      self.addButton.setTitle("Add")
    }
  }

  func setSuccessTitle() {
    guard let activity = activity else {
      return
    }

    addButton.setTitle("Success!")
    updateDailyTotalLabel(with: Entries.sharedInstance.totalDailyValue(for: activity))
    delay(1) {
      self.addButton.setTitle("Add")
    }
  }

  func updateDailyTotalLabel(with value: Int) {
    guard let activity = activity else {
      return
    }

    if activity.isBoolValue {
      let boolValue: String = value == 0 ? "True" : "False"
      DispatchQueue.main.async {
        self.dailyTotalLabel.setText(boolValue)
      }
    } else {
      DispatchQueue.main.async {
        self.dailyTotalLabel.setText("\(value)")
      }
    }
  }

  func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
      deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
  }
  // MARK: - CloudKit

  func saveEntries() {
//    if ckManager.iCloudAccountIsAvailable {
//      print("Watch saving directly to iCloud")
//      ckCentral.saveDate(floData.lastDate, viaWC: false)
//    } else {
      // send to iPhone via Watch Connectivity
//      NotificationCenter.default.post(name:
//        NSNotification.Name(rawValue:
//          NotificationDrinkDateOnWatch), object: nil)
//    }

    // Update UserDefaults
//    UserDefaults.standard.set(floData.drinkTotal, forKey: LocalCache.drinkTotal.rawValue)
  }
}
