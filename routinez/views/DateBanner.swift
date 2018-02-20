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

class AddCircle: UIButton {

  init() {
    super.init(frame: .zero)

    backgroundColor = .white
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private struct Constants {
    static let plusLineWidth: CGFloat = 4.0
    static let plusButtonScale: CGFloat = 0.6
    static let halfPointShift: CGFloat = 0.5
  }

  private var halfWidth: CGFloat {
    return bounds.width / 2
  }

  private var halfHeight: CGFloat {
    return bounds.height / 2
  }

  override func draw(_ rect: CGRect) {
    let path = UIBezierPath(ovalIn: rect)
    UIColor.plum.setFill()
    path.fill()

    let plusWidth: CGFloat = min(bounds.width, bounds.height) * Constants.plusButtonScale
    let halfPlusWidth = plusWidth / 2
    let plusPath = UIBezierPath()
    plusPath.lineWidth = Constants.plusLineWidth

    plusPath.move(to: CGPoint(
      x: halfWidth - halfPlusWidth + Constants.halfPointShift,
      y: halfHeight + Constants.halfPointShift))

    plusPath.addLine(to: CGPoint(
      x: halfWidth + halfPlusWidth + Constants.halfPointShift,
      y: halfHeight + Constants.halfPointShift))

    plusPath.move(to: CGPoint(
      x: halfWidth + Constants.halfPointShift,
      y: halfHeight - halfPlusWidth + Constants.halfPointShift))

    plusPath.addLine(to: CGPoint(
      x: halfWidth + Constants.halfPointShift,
      y: halfHeight + halfPlusWidth + Constants.halfPointShift))

    UIColor.white.setStroke()
    plusPath.stroke()
  }
}