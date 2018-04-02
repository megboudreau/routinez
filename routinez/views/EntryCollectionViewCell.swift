//
//  ActivityCollectionViewCell.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-26.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

enum ActivityCellType {
  case filled(activity: Activity, color: UIColor)
  case add
  case empty

  static func == (_ lhs: ActivityCellType, _ rhs: ActivityCellType) -> Bool {
    switch (lhs, rhs) {
    case (.add, .add):
      return true
    case (.empty, .empty):
      return true
    case (.filled, .filled):
      return true
    default:
      return false
    }
  }
}

class ActivityCollectionViewCell: UICollectionViewCell {

  let activityNameLabel = UILabel()
  var activity: Activity?
  let plusButton = AddCircle(circleFill: .clear, plusFill: .white)
  var cellType: ActivityCellType? {
    didSet {
      guard let cellType = cellType else {
        return
      }

      switch cellType {
      case .filled(let activity, let color):
        self.activity = activity
        activityNameLabel.isHidden = false
        plusButton.isHidden = true
        backgroundColor = color
        activityNameLabel.text = activity.name
      case .add:
        self.activity = nil
        activityNameLabel.isHidden = true
        backgroundColor = .chartGrey
        plusButton.isHidden = false
      case .empty:
        self.activity = nil
        activityNameLabel.isHidden = true
        plusButton.isHidden = true
        backgroundColor = .chartGrey
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: .zero)

    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func commonInit() {
    backgroundColor = .chartGrey
    layer.cornerRadius = 5

    plusButton.isHidden = true
    plusButton.isUserInteractionEnabled = true
    addSubviewForAutoLayout(plusButton)
    plusButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    plusButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    plusButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.40).isActive = true
    plusButton.widthAnchor.constraint(equalTo: heightAnchor).isActive = true

    activityNameLabel.textColor = .white
    activityNameLabel.font = UIFont.systemFont(ofSize: 18)
    activityNameLabel.numberOfLines = 2
    activityNameLabel.adjustsFontSizeToFitWidth = true
    activityNameLabel.textAlignment = .center
    addSubviewForAutoLayout(activityNameLabel)
    activityNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    activityNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    activityNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
    activityNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
  }
}
