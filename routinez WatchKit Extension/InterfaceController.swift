//
//  InterfaceController.swift
//  routinez WatchKit Extension
//
//  Created by Megan Boudreau on 2017-10-17.
//  Copyright © 2017 Megan Boudreau. All rights reserved.
//

import WatchKit
import WatchConnectivity

class InterfaceController: WKInterfaceController {

  @IBOutlet var caloriePicker: WKInterfacePicker!
  @IBOutlet var dailyTotalLabel: WKInterfaceLabel!
  @IBOutlet var addButton: WKInterfaceButton!

  static var currentDailyTotal: Int = 0
  var selectedItem: Int = 0
  let session: WCSession = 

  override func awake(withContext context: Any?) {
    super.awake(withContext: context)

    session.startSession()
    processApplicationContext(session.receivedContext!)
    session.watchContextUpdateHandler = processApplicationContext(_:)

    let calories = stride(from:0, to: 2500, by: 10)
    let pickerItems: [WKPickerItem] = calories.map {
      let pickerItem = WKPickerItem()
      pickerItem.title = "\($0)"
      pickerItem.caption = "Calories"
      return pickerItem
    }

    caloriePicker.setItems(pickerItems)
  }

  override func willActivate() {
    super.willActivate()

    processApplicationContext(session.receivedContext!)
  }

  override func didDeactivate() {
    super.didDeactivate()
  }

  @IBAction func didTapAddButton() {
    let caloriesDict = ["caloriesAdded": selectedItem]
    addButton.setTitle("Sending...")
    session.updateApplicationContext(
      with: caloriesDict,
      successHandler: setSuccessTitle,
      errorHandler: setErrorTitle)
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
    addButton.setTitle("Success!")
    InterfaceController.currentDailyTotal += selectedItem
    updateDailyCalories(with: InterfaceController.currentDailyTotal)
    delay(1) {
      self.addButton.setTitle("Add")
    }
  }

  func processApplicationContext(_ context: [String: Any]) {
    guard let context = context as? [String: Int],
      let dailyTotal = context["dailyTotal"] else {
        return
    }

    InterfaceController.currentDailyTotal = dailyTotal
    updateDailyCalories(with: InterfaceController.currentDailyTotal)
  }

  func updateDailyCalories(with calories: Int) {
    DispatchQueue.main.async {
      self.dailyTotalLabel.setText("\(calories)")
    }
  }

  func sendCaloriesToPhone(_ message: [String: Any]) {
    addButton.setTitle("Sending..")

    session.sendMessage(message, replyHandler: { responseDict in
      guard let daily = responseDict["daily"] else {
        return
      }
      self.dailyTotalLabel.setText("\(daily)")
      self.addButton.setTitle("Add")
    }, errorHandler: { _ in
      self.addButton.setTitle("Try again")
    })
  }

  func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
      deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
  }
}

extension InterfaceController: WCSessionDelegate {

}
