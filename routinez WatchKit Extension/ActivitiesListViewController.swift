//
//  ActivitiesListViewController.swift
//  routinez WatchKit Extension
//
//  Created by Megan Boudreau on 2018-03-26.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ActivitiesListViewController: WKInterfaceController {

  @IBOutlet var noActivitiesLabel: WKInterfaceLabel!
  @IBOutlet var activityTable: WKInterfaceTable!
  var activities: [Activity]?

  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    noActivitiesLabel.setHidden(true)

    guard let activities = Entries.sharedInstance.cachedActivities else {
      noActivitiesLabel.setHidden(false)
      return
    }

    self.activities = activities
    guard !activities.isEmpty else {
      noActivitiesLabel.setHidden(false)
      return
    }

    activityTable.setNumberOfRows(activities.count, withRowType: "activityRowType")
    let names = activities.map { $0.name }
    for (index, name) in names.enumerated() {
      let controller = activityTable.rowController(at: index) as! ActivityRowController
      controller.activityLabel.setText(name)
    }
  }

  override func willActivate() {
    super.willActivate()

    guard let activities = Entries.sharedInstance.cachedActivities else {
      return
    }

    noActivitiesLabel.setHidden(true)
    activityTable.setNumberOfRows(activities.count, withRowType: "activityRowType")
    let names = activities.map { $0.name }
    for (index, name) in names.enumerated() {
      let controller = activityTable.rowController(at: index) as! ActivityRowController
      controller.activityLabel.setText(name)
    }
  }

  override func didDeactivate() {
    ExtensionDelegate.reloadComplications()
    super.didDeactivate()
  }

  override func contextForSegue(withIdentifier
    segueIdentifier: String, in table: WKInterfaceTable,
                             rowIndex: Int) -> Any? {
    guard let activities = activities else {
      return nil
    }
    return activities[rowIndex]
  }
}
