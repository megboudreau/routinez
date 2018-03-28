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

  var selectedActivity: Activity?

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
      dateBanner.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16).isActive = true
    } else {
      dateBanner.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
    }

    view.addSubview(dailyCircleChart)
    dailyCircleChart.chartValueSelected = didSelectActivity
    dailyCircleChart.chartNothingSelected = updateLabels
    dailyCircleChart.translatesAutoresizingMaskIntoConstraints = false
    dailyCircleChart.topAnchor.constraint(equalTo: dateBanner.bottomAnchor, constant: 36).isActive = true
    dailyCircleChart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    dailyCircleChart.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
    dailyCircleChart.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
    dailyCircleChart.fillChart()

    seeActivityData.setTitleColor(.white, for: .normal)
    seeActivityData.addTarget(self, action: #selector(seeDataForActivity), for: .touchUpInside)
    seeActivityData.isHidden = true
    view.addSubviewForAutoLayout(seeActivityData)
    seeActivityData.centerXAnchor.constraint(equalTo: dailyCircleChart.centerXAnchor).isActive = true
    seeActivityData.centerYAnchor.constraint(equalTo: dailyCircleChart.centerYAnchor).isActive = true
    seeActivityData.heightAnchor.constraint(equalTo: dailyCircleChart.heightAnchor, multiplier: 0.35).isActive = true
    seeActivityData.widthAnchor.constraint(equalTo: dailyCircleChart.heightAnchor, multiplier: 0.35).isActive = true

    view.addSubview(selectedTotalLabel)
    selectedTotalLabel.sizeToFit()
    selectedTotalLabel.font = UIFont.systemFont(ofSize: 24)
    selectedTotalLabel.textColor = .plum
    selectedTotalLabel.translatesAutoresizingMaskIntoConstraints = false
    selectedTotalLabel.topAnchor.constraint(equalTo: dailyCircleChart.bottomAnchor, constant: 16).isActive = true
    selectedTotalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    seeActivityData.titleLabel?.numberOfLines = 2
    seeActivityData.titleLabel?.adjustsFontSizeToFitWidth = true
    seeActivityData.titleLabel?.textAlignment = .center
  }

  func updateDisplay() {
    dailyCircleChart.fillChart(animate: false)
    updateLabels()
    if let selectedActivity = selectedActivity {
      didSelectActivity(activityName: selectedActivity.name)
    }
  }

  func didSelectActivity(activityName: String) {
    guard let activity = Entries.sharedInstance.activityForName(activityName) else {
      return
    }
    let total = Entries.sharedInstance.totalDailyValue(for: activity)
    let text = "\(activityName): \(total)\(activity.unitOfMeasurement.shortForm)"
    selectedTotalLabel.text = text

    updateLabels()
    seeActivityData.setTitle("View data: \(activityName)", for: .normal)
    self.selectedActivity = Entries.sharedInstance.activityForName(activityName)
  }

  func updateLabels() {
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
