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

  let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

  var weekTableView = UITableView()

  override func viewDidLoad() {
    super.viewDidLoad()

    weekTableView.tableFooterView = UIView(frame: CGRect.zero)
    weekTableView.isScrollEnabled = false
    weekTableView.separatorStyle = .none

    view.addSubview(weekTableView)
    weekTableView.translatesAutoresizingMaskIntoConstraints = false
    weekTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
    weekTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    weekTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    weekTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    weekTableView.delegate = self
    weekTableView.dataSource = self

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

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 7
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
    cell.textLabel?.text = days[indexPath.row]
    cell.detailTextLabel?.text = "\(Entries.sharedInstance.totalDailyValueForEntry("Calories"))"
    cell.selectionStyle = .none
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return (view.bounds.height - 60) / 7
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
