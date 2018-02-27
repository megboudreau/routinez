//
//  EntryCollectionViewCell.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-26.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

enum EntryCellType {
  case filled(entryName: String)
  case add
  case empty

  static func == (_ lhs: EntryCellType, _ rhs: EntryCellType) -> Bool {
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

class EntryCollectionViewCell: UICollectionViewCell {

  let entryNameLabel = UILabel()
  let plusButton = AddCircle(circleFill: .clear, plusFill: .white)
  var cellType: EntryCellType? {
    didSet {
      guard let cellType = cellType else {
        return
      }
      if case .filled(let entryName) = cellType {
        entryNameLabel.text = entryName
      }
    }
  }
  var index: Int? {
    didSet {
      guard let index = index,
        let cellType = cellType else {
        return
      }

      switch cellType {
      case .filled(let name):
        print(name)
        backgroundColor = UIColor.chartColors[index]
      case .add:
        plusButton.isHidden = false
      case .empty:
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
    addSubviewForAutoLayout(plusButton)
    plusButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    plusButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    plusButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.40).isActive = true
    plusButton.widthAnchor.constraint(equalTo: heightAnchor).isActive = true

    entryNameLabel.textColor = .white
    entryNameLabel.font = UIFont.systemFont(ofSize: 24)
    entryNameLabel.adjustsFontSizeToFitWidth = true
    entryNameLabel.sizeToFit()
    addSubviewForAutoLayout(entryNameLabel)
    entryNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    entryNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }
}
