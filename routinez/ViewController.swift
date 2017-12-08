//
//  ViewController.swift
//  routinez
//
//  Created by Megan Boudreau on 2017-10-17.
//  Copyright © 2017 Megan Boudreau. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {

  @IBOutlet weak var dailyTotalLabel: UILabel!
  @IBOutlet weak var weekyTotalLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    WatchSessionManager.sharedManager.iosContextUpdateHandler = receivedApplicationContext(_:)

    dailyTotalLabel.text = "\(DefaultsManager.dailyTotal)"
    weekyTotalLabel.text = "\(DefaultsManager.weeklyTotal)"

    let caloriesDict = [
      "dailyTotal": DefaultsManager.dailyTotal,
      "weeklyTotal": DefaultsManager.weeklyTotal
    ]

    WatchSessionManager.sharedManager.updateApplicationContext(with: caloriesDict, successHandler: {
      print("Success")
    } , errorHandler: {
      print("error")
    })

    if let context = WatchSessionManager.sharedManager.receivedContext {
      receivedApplicationContext(context)
    }
  }

  func updateTotalLabels() {
    DispatchQueue.main.async {
      self.dailyTotalLabel.text = "\(DefaultsManager.dailyTotal)"
      self.weekyTotalLabel.text = "\(DefaultsManager.weeklyTotal)"
    }
  }

  func receivedApplicationContext(_ context: [String: Any]) {
    guard let dailyCalories = context["caloriesAdded"] as? Int else {
      print("Nothing to see here")
      return
    }

    DefaultsManager.addCalories(dailyCalories)
    updateTotalLabels()
  }
}
