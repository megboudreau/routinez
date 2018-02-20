//
//  DateBanner.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-19.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

class DateBanner: UIView {

  var dateLabel = UILabel()
  var currentFormattedDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter.string(from: Date())
  }

  init() {
    super.init(frame: .zero)

    clipsToBounds = true
    backgroundColor = .plum
    dateLabel.textColor = .white
    dateLabel.adjustsFontSizeToFitWidth = true
    dateLabel.font = UIFont.systemFont(ofSize: 20)
    dateLabel.text = currentFormattedDate
    dateLabel.sizeToFit()

    addSubview(dateLabel)
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func layoutSubviews() {
    layer.cornerRadius = bounds.height/2

    super.layoutSubviews()
  }
}
