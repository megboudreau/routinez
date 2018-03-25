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
  var activity: Activity?

//  let ckManager = CloudKitManager.sharedInstance()

  override func awake(withContext context: Any?) {
    super.awake(withContext: context)

  }

  override func willActivate() {
    super.willActivate()

    if let currentActivity = Entries.sharedInstance.cachedActivities?.first {
      self.activity = currentActivity
    } else {
      let a = Activity(name: "Calories")
      self.activity = a
      Entries.sharedInstance.cacheNewActivity(a)
    }

    let entryValues = stride(from:0, to: 2500, by: 10)
    let pickerItems: [WKPickerItem] = entryValues.map {
      let pickerItem = WKPickerItem()
      pickerItem.title = "\($0)"
      pickerItem.caption = activity?.name
      return pickerItem
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
    updateDailyTotal(with: currentDailyTotal)

    // TODO create different view controllers based on entries
  }

  @IBAction func didTapAddButton() {
    guard let activity = activity else {
      return
    }

    let entry = Entry(timestamp: Date(), value: selectedItem)
    Entries.sharedInstance.cacheNewEntry(entry, for: activity)

    addButton.setTitle("Sending...")
    ExtensionDelegate.sendEntryToPhone(
      successHandler: setSuccessTitle,
      errorHandler: setErrorTitle
    )
  }

  @IBAction func pickerSelectedItemChanged(_ value: Int) {
    selectedItem = (value * 10)
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
    updateDailyTotal(with: Entries.sharedInstance.totalDailyValue(for: activity))
    delay(1) {
      self.addButton.setTitle("Add")
    }
  }

  func updateDailyTotal(with value: Int) {
    DispatchQueue.main.async {
      self.dailyTotalLabel.setText("\(value)")
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
