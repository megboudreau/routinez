//
//  CreateEntryViewController.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-26.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {

  let trackingLabel = UILabel()
  let collectionView: UICollectionView
  let layout = UICollectionViewFlowLayout()

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
    collectionView.register(EntryCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    collectionView.backgroundColor = .white
    view.addSubviewForAutoLayout(collectionView)
    collectionView.topAnchor.constraint(equalTo: trackingLabel.bottomAnchor, constant: 24).isActive = true
    collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 48).isActive = true
  }
}

extension CreateEntryViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = view.bounds.width
    let height = view.bounds.height
    let insideSpacing: CGFloat = 16
    let outsideSpacing: CGFloat = 24

    return CGSize(width: width/2 - (insideSpacing + outsideSpacing), height: height/8)
  }
}

extension CreateEntryViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EntryCollectionViewCell
    switch indexPath.row {
    case 0:
      cell.cellType = .filled(entryName: "Calories")
    case 1:
      cell.cellType = .add
    default:
      cell.cellType = .empty
    }

    cell.index = indexPath.row
    return cell
  }
}
