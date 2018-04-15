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
  let collectionView: UICollectionView
  let layout = UICollectionViewFlowLayout()

  var totalCurrentActivities: Int {
    if ActivitiesViewController.activities == nil {
      ActivitiesViewController.activities = Entries.sharedInstance.cachedActivities
      collectionView.reloadData()
    }
    return Entries.sharedInstance.activityKeys?.count ?? 0
  }

  static var activities: [Activity]?

  init() {
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 24
    collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    trackingLabel.text = "I am tracking..."
    trackingLabel.font = UIFont.systemFont(ofSize: 24)
    trackingLabel.textColor = .plum
    trackingLabel.sizeToFit()
    view.addSubviewForAutoLayout(trackingLabel)
    trackingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
    trackingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true

    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(ActivityCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    collectionView.backgroundColor = .white
    collectionView.showsVerticalScrollIndicator = false
    view.addSubviewForAutoLayout(collectionView)
    collectionView.topAnchor.constraint(equalTo: trackingLabel.bottomAnchor, constant: 24).isActive = true
    collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
    if #available(iOS 11.0, *) {
      let bottomInset = view.safeAreaInsets.bottom + 60
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomInset).isActive = true
    } else {
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
    }

    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
    longPress.delegate = self
    view.addGestureRecognizer(longPress)

    ActivitiesViewController.activities = Entries.sharedInstance.cachedActivities
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if ActivitiesViewController.activities == nil {
      ActivitiesViewController.activities = Entries.sharedInstance.cachedActivities
      collectionView.reloadData()
    }
  }
}

extension ActivitiesViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = view.bounds.width
    let height = view.bounds.height
    let insideSpacing: CGFloat = 16
    let outsideSpacing: CGFloat = 24

    return CGSize(width: width/2 - (insideSpacing + outsideSpacing), height: height/8)
  }
}

extension ActivitiesViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ActivityCollectionViewCell

    guard let activities = ActivitiesViewController.activities else {
      if indexPath.row == 0 {
        cell.cellType = .add
        return cell
      }
      cell.cellType = .empty
      return cell
    }

    let addIndex = activities.count
    if activities.count > indexPath.item {
      let activity = activities[indexPath.item]
      cell.activity = activity
      cell.cellType = .filled(activity: activity, color: activity.color)
      return cell
    } else if indexPath.item == addIndex {
      cell.cellType = .add
      return cell
    }

    cell.cellType = .empty
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! ActivityCollectionViewCell
    guard let cellType = cell.cellType else {
      return
    }
    switch cellType {
    case .add:
      let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
      feedbackGenerator.prepare()
      feedbackGenerator.impactOccurred()

      let color = UIColor.activityColors[indexPath.item]
      let vc = CreateActivityViewController(color: color)
      navigationController?.pushViewController(vc, animated: true)
    case .filled(let activity, _):
      print(activity.name)
    // TODO:
      // allow to edit activity
    default:
      return
    }
  }

  @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
    let location = sender.location(in: collectionView)
    if let index = collectionView.indexPathForItem(at: location),
      let cell = collectionView.cellForItem(at: index) as? ActivityCollectionViewCell,
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
          self.collectionView.reloadData()
          alert.dismiss(animated: true, completion: nil)
        }))

      present(alert, animated: true, completion: nil)
    }
  }
}
