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

  var session: WCSession?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    dailyTotalLabel.text = "\(DefaultsManager.dailyTotal)"
    weekyTotalLabel.text = "\(DefaultsManager.weeklyTotal)"

    let caloriesDict = [
      "dailyTotal": DefaultsManager.dailyTotal,
      "weeklyTotal": DefaultsManager.weeklyTotal
    ]

    if WCSession.isSupported() {
      session = WCSession.default
      session?.delegate = self
      session?.activate()
    }

//    if let context = WatchSessionManager.sharedManager.receivedContext {
//      receivedApplicationContext(context)
//    }
  }

  func updateTotalLabels() {
    dailyTotalLabel.text = "\(DefaultsManager.dailyTotal)"
    weekyTotalLabel.text = "\(DefaultsManager.weeklyTotal)"
  }

  func receivedApplicationContext(_ context: [String: Any]) {
    guard let dailyCalories = context["caloriesAdded"] as? Int else {
      return
    }

    DefaultsManager.addCalories(dailyCalories)
    DispatchQueue.main.async {
      self.dailyTotalLabel.text = "\(DefaultsManager.weeklyTotal)"
      self.weekyTotalLabel.text = "\(DefaultsManager.weeklyTotal)"
    }
  }
}

extension ViewController: WCSessionDelegate {
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    print("Activation did complete with in ios")
  }

  func sessionDidBecomeInactive(_ session: WCSession) {
    print("Did become Inactive in ios")
  }

  func sessionDidDeactivate(_ session: WCSession) {
    print("session did deactivate in ios")
  }


  func sessionWatchStateDidChange(_ session: WCSession) {
    // you can find out here if the user enabled their complication
//    print(session.isComplicationEnabled)
    print("sessionWatchStateDidhange")
  }

}

//Background tranfers
// app doesnt need information immediately - recommended
// 3 types
// application context
// user info transfer
// file transfer


// Interactive messaging
// iphone and watch app communicate
// or youre on your watch and you wanna trigger something to happen on the ios device

