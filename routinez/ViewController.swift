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
  let dailyCircleChart = DailyCircleChart()
  let circularButton = CircularButton()
  let selectedTotalLabel = UILabel()
  let seeActivityData = CircularButton()
  let addEntryView = AddEntryView()

  var selectedActivity: Activity?
  var selectedActivityColor: UIColor?

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

    view.backgroundColor = .white

    notificationObserver = notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NotificationEntryAddedOnWatch), object: nil, queue: nil) { (notification:Notification) -> Void in
      self.updateDisplay()
    }

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

    dailyCircleChart.fillChart(animate: false)
  }

  func addInitialViews() {
    let dateBanner = DateBanner()
    view.addSubview(dateBanner)

    dateBanner.translatesAutoresizingMaskIntoConstraints = false
    dateBanner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    dateBanner.heightAnchor.constraint(equalToConstant: 50).isActive = true
    dateBanner.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
    if #available(iOS 11.0, *) {
      let safeArea = view.safeAreaLayoutGuide
      dateBanner.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: -20).isActive = true
    } else {
      dateBanner.topAnchor.constraint(equalTo: view.topAnchor, constant: -20).isActive = true
    }

    view.addSubview(selectedTotalLabel)
    selectedTotalLabel.sizeToFit()
    selectedTotalLabel.font = UIFont.systemFont(ofSize: 20)
    selectedTotalLabel.text = "-"
    selectedTotalLabel.isHidden = true
    selectedTotalLabel.textColor = .black
    selectedTotalLabel.translatesAutoresizingMaskIntoConstraints = false
    selectedTotalLabel.topAnchor.constraint(equalTo: dateBanner.bottomAnchor).isActive = true
    selectedTotalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    view.addSubview(dailyCircleChart)
    dailyCircleChart.clipsToBounds = false
    dailyCircleChart.layer.masksToBounds = false
    dailyCircleChart.chartValueSelected = didSelectActivity
    dailyCircleChart.chartNothingSelected = didSelectNothing
    dailyCircleChart.translatesAutoresizingMaskIntoConstraints = false
    dailyCircleChart.topAnchor.constraint(equalTo: selectedTotalLabel.bottomAnchor, constant: 36).isActive = true
    dailyCircleChart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    dailyCircleChart.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
    dailyCircleChart.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
    dailyCircleChart.fillChart()

    seeActivityData.setTitleColor(.black, for: .normal)
    seeActivityData.addTarget(self, action: #selector(seeDataForActivity), for: .touchUpInside)
    seeActivityData.isHidden = true
    view.addSubviewForAutoLayout(seeActivityData)
    seeActivityData.centerXAnchor.constraint(equalTo: dailyCircleChart.centerXAnchor).isActive = true
    seeActivityData.centerYAnchor.constraint(equalTo: dailyCircleChart.centerYAnchor).isActive = true
    seeActivityData.heightAnchor.constraint(equalTo: dailyCircleChart.heightAnchor, multiplier: 0.40).isActive = true
    seeActivityData.widthAnchor.constraint(equalTo: dailyCircleChart.heightAnchor, multiplier: 0.40).isActive = true

    seeActivityData.titleLabel?.numberOfLines = 3
    seeActivityData.titleLabel?.adjustsFontSizeToFitWidth = true
    seeActivityData.titleLabel?.textAlignment = .center

    view.addSubviewForAutoLayout(addEntryView)
    addEntryView.newEntrySaved = updateDisplay
    addEntryView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    addEntryView.topAnchor.constraint(equalTo: dailyCircleChart.bottomAnchor, constant: 16).isActive = true
    addEntryView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -76).isActive = true
    addEntryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
  }

  func updateDisplay() {
    dailyCircleChart.fillChart(animate: false)
    updateLabels()
    if let selectedActivity = selectedActivity,
      let selectedActivityColor = selectedActivityColor {
      didSelectActivity(activityName: selectedActivity.name, color: selectedActivityColor)
    }
  }

  func didSelectActivity(activityName: String, color: UIColor) {
    guard let activity = Entries.sharedInstance.activityForName(activityName) else {
      return
    }
    let stringTotal = Entries.sharedInstance.stringTotalDailyValue(for: activity)
    selectedTotalLabel.text = "\(activity.name): \(stringTotal)"

    seeActivityData.setTitle("View data:\n \(activityName)", for: .normal)
    self.selectedActivity = Entries.sharedInstance.activityForName(activityName)
    self.selectedActivityColor = color
    updateLabels()
  }

  func didSelectNothing() {
    selectedActivity = nil
    updateLabels()
  }

  func updateLabels() {
    addEntryView.activity = selectedActivity
    addEntryView.color = selectedActivityColor
    seeActivityData.isHidden = !dailyCircleChart.valueSelected
    selectedTotalLabel.isHidden = !dailyCircleChart.valueSelected
  }

  @objc func seeDataForActivity() {
    guard let activity = selectedActivity else {
      return
    }

    let viewController = LineChartTabBarController(activity: activity)
    navigationController?.pushViewController(viewController, animated: true)
  }

  func successHandler() {
    print("success")
  }

  func errorHandler() {
    print("error")
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
