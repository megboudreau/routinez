//
//  ViewController.swift
//  routinez
//
//  Created by Megan Boudreau on 2017-10-17.
//  Copyright © 2017 Megan Boudreau. All rights reserved.
//

import UIKit
import WatchConnectivity
import CloudKit

class ViewController: UIViewController {

  static var subscriptionIsLocallyCached: Bool = false

  var weekTableView = UITableView()
  var dailyTotalLabel = UILabel()
  let addButton = UIButton()

  var currentFormattedDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: Date())
  }

  // MARK: Notifications
  lazy var notificationCenter: NotificationCenter = {
    return NotificationCenter.default
  }()
  var notificationObserver: NSObjectProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

    notificationObserver = notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NotificationEntryAddedOnWatch), object: nil, queue: nil) { (notification:Notification) -> Void in
      self.updateDisplay()
    }

    addButton.backgroundColor = .plum
    addButton.setTitle("AddValue", for: .normal)
    addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
    view.addSubview(addButton)

    dailyTotalLabel.text = currentFormattedDate
    dailyTotalLabel.sizeToFit()
    view.addSubview(dailyTotalLabel)

    addButton.translatesAutoresizingMaskIntoConstraints = false
    addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    dailyTotalLabel.translatesAutoresizingMaskIntoConstraints = false
    dailyTotalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    dailyTotalLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor).isActive = true

    addInitialViews()

    // record identifier of the user that's signed in on the device
    CKContainer.default().fetchUserRecordID { (recordID, error) in
      if let error = error {
        print(error)
      } else if let recordID = recordID {
        print(recordID)
      }
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

  }

  func addInitialViews() {
    let dateBanner = DateBanner()
    view.addSubview(dateBanner)

    dateBanner.translatesAutoresizingMaskIntoConstraints = false
    dateBanner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    dateBanner.heightAnchor.constraint(equalToConstant: 70).isActive = true
    dateBanner.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
    if #available(iOS 11.0, *) {
      let safeArea = view.safeAreaLayoutGuide
      dateBanner.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 65).isActive = true
    } else {
      dateBanner.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
    }

    let dailyCircleChart = DailyCircleChart()
    view.addSubview(dailyCircleChart)

    dailyCircleChart.translatesAutoresizingMaskIntoConstraints = false
    dailyCircleChart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    dailyCircleChart.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    dailyCircleChart.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90).isActive = true
    dailyCircleChart.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90).isActive = true
  }

  func updateDisplay() {
    let total = Entries.sharedInstance.totalDailyValueForEntry("Calories")
    dailyTotalLabel.text = "Total: \(total)"
  }

  func successHandler() {
    print("success")
  }

  func errorHandler() {
    print("error")
  }

  @objc func didTapAdd() {
    Entries.sharedInstance.cacheNewEntry(Entry(name: "Calories", timestamp: Date(), value: 100))
    AppDelegate.sendEntryToWatch(successHandler: successHandler, errorHandler: errorHandler)
    updateDisplay()
  }
}


// CLOUDKIT STUFF

// Highest level: Containers
// public and private containers (and shared)

// Mid Level: Zones
// each container has a default zone where records will go if you dont specify a zone for them
// You can have custom zones in the containers

// Lowest level: Records (key value store)

// Recommended Work flow:
// 1) When app launches, fetch changes from the server
// 2) Subscribe to future changes (push notifications from Cloudkit)
// 3) On push from Cloudkit, fetch new changes
