//
//  CalendarDayCollectionViewCell.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-04-12.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

class CalendarDayCollectionViewCell: UICollectionViewCell {

  let dayNumberLabel = UILabel()
  let circleView = CircleView()
  var taskCompleted: Bool = false {
    didSet {
      updateView()
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
    backgroundColor = .white

    addSubviewForAutoLayout(circleView)
    circleView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    circleView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    circleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9).isActive = true
    circleView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true

    dayNumberLabel.font = UIFont.systemFont(ofSize: 30)
    addSubviewForAutoLayout(dayNumberLabel)
    dayNumberLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    dayNumberLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    updateView()
  }

  func updateView() {
    circleView.isHidden = !taskCompleted
    dayNumberLabel.textColor = taskCompleted ? .white : .black
  }
}
