//
//  DayTableViewCell.swift
//  routinez
//
//  Created by Megan Boudreau on 2017-12-08.
//  Copyright © 2017 Megan Boudreau. All rights reserved.
//

import UIKit

class DayTableViewCell: UITableViewCell {

  var day: String? {
    didSet {
      updateDayLabel()
    }
  }
  let dayLabel = UILabel()

  init() {
    super.init(style: .default, reuseIdentifier: "DayTableViewCell")
    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViews() {}

  func updateDayLabel() {
    dayLabel.text = day
  }


}
