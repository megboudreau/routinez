//
//  ActivitiesViewController.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-26.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

class ActivitiesViewController: UIViewController, UIGestureRecognizerDelegate {

  let trackingLabel = UILabel()
  let tableView = UITableView()

  var totalCurrentActivities: Int {
    if ActivitiesViewController.activities == nil {
      ActivitiesViewController.activities = Entries.sharedInstance.cachedActivities
      tableView.reloadData()
    }
    return Entries.sharedInstance.activityKeys?.count ?? 0
  }

  static var activities: [Activity]?

  var currentFormattedDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: Date())
  }

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(ActivityTableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.estimatedRowHeight = 124
    tableView.rowHeight = UITableViewAutomaticDimension
    view.addSubview(tableView)
    tableView.pinToSuperviewEdges()

    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
    longPress.delegate = self
    view.addGestureRecognizer(longPress)

    ActivitiesViewController.activities = Entries.sharedInstance.cachedActivities

    let plusButton = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(addActivity))
    navigationItem.rightBarButtonItem = plusButton

    navigationItem.title = currentFormattedDate
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if ActivitiesViewController.activities == nil {
      ActivitiesViewController.activities = Entries.sharedInstance.cachedActivities
      tableView.reloadData()
    }
  }

  @objc func addActivity() {
    let color = UIColor.activityColors[totalCurrentActivities]
    let vc = CreateActivityViewController(color: color)
    navigationController?.pushViewController(vc, animated: true)
  }
}

extension ActivitiesViewController: UITableViewDataSource, UITableViewDelegate {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return totalCurrentActivities
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let activities = ActivitiesViewController.activities else {
      return UITableViewCell()
    }

    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ActivityTableViewCell
    cell.activity = activities[indexPath.row]
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    feedbackGenerator.prepare()
    feedbackGenerator.impactOccurred()

    let cell = tableView.cellForRow(at: indexPath) as! ActivityTableViewCell
    cell.toggleCellState()
    tableView.beginUpdates()
    tableView.endUpdates()
  }

  @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
    let location = sender.location(in: tableView)
    if let index = tableView.indexPathForRow(at: location),
      let cell = tableView.cellForRow(at: index) as? ActivityTableViewCell,
      let activity = cell.activity {
      let alert = UIAlertController(
        title: "Delete this Activity?",
        message: "Are you sure you want to delete this activity?",
        preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        alert.dismiss(animated: true, completion: nil)
      }))
      alert.addAction(
        UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
          Entries.sharedInstance.deleteActivityAndEntries(activity)
          ActivitiesViewController.activities = Entries.sharedInstance.cachedActivities
          self.tableView.reloadData()
          alert.dismiss(animated: true, completion: nil)
        }))

      present(alert, animated: true, completion: nil)
    }
  }
}
