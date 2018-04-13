//
//  CalendarViewController.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-04-12.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

  let daysOfWeek = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri" ,"Sat"]

  let calendarCollectionView: UICollectionView
  let layout = UICollectionViewFlowLayout()

  init() {
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 6
    layout.minimumInteritemSpacing = 6
    calendarCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    calendarCollectionView.delegate = self
    calendarCollectionView.dataSource = self
    calendarCollectionView.register(CalendarDayCollectionViewCell.self, forCellWithReuseIdentifier: "calendar")
    calendarCollectionView.backgroundColor = .white
    calendarCollectionView.showsVerticalScrollIndicator = false


    view.addSubviewForAutoLayout(calendarCollectionView)
    calendarCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    calendarCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    calendarCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    calendarCollectionView.heightAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
    calendarCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
  }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = view.bounds.width

    let squareSize = width/7 - 16

    return CGSize(width: squareSize, height: squareSize)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 6, left: 6, bottom: 0, right: 0)
  }
}

extension CalendarViewController: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 5
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 7
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendar", for: indexPath) as! CalendarDayCollectionViewCell

    cell.dayNumberLabel.text = "\(indexPath.row)"
    cell.taskCompleted = true
    return cell
  }
}


