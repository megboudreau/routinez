//
//  ActivityTableViewCell.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-26.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

  enum CellState {
    case expanded, collapsed
  }

  let activityStack = UIStackView()
  let activityNameLabel = UILabel()
  let todaysTotalLabel = UILabel()
  let thisWeeksTotalLabel = UILabel()
  let thisMonthsTotalLabel = UILabel()
  let viewChartsButton = UIButton()
  let addEntryView = AddEntryView()

  private var cellState: CellState = .collapsed

  var activity: Activity? {
    didSet {
      guard let activity = activity else {
        return
      }
      activityNameLabel.text = activity.name
      addEntryView.activity = activity
      todaysTotalLabel.text = "Today: \(Entries.sharedInstance.totalDailyValue(for: activity))"
      viewChartsButton.setTitleColor(activity.color, for: .normal)
      backgroundColor = activity.color
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    invalidateIntrinsicContentSize()
  }

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func commonInit() {
    selectionStyle = .none

    activityStack.backgroundColor = .clear
    activityStack.alignment = .fill
    activityStack.axis = .vertical
    activityStack.distribution = .equalSpacing
    activityStack.spacing = 16

    contentView.addSubview(activityStack)
    activityStack.pinToSuperviewEdges(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))

    activityStack.addArrangedSubview(activityNameLabel)
    activityStack.addArrangedSubview(todaysTotalLabel)
    activityStack.addArrangedSubview(addEntryView)
    activityStack.addArrangedSubview(viewChartsButton)

    activityNameLabel.translatesAutoresizingMaskIntoConstraints = false
    activityNameLabel.textColor = .white
    activityNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
    activityNameLabel.numberOfLines = 2
    activityNameLabel.textAlignment = .center
    let heightConstraint = NSLayoutConstraint(
      item: activityNameLabel,
      attribute: .height,
      relatedBy: .equal,
      toItem: nil,
      attribute: .notAnAttribute,
      multiplier: 1,
      constant: 124
    )

    todaysTotalLabel.translatesAutoresizingMaskIntoConstraints = false
    todaysTotalLabel.textColor = .white
    todaysTotalLabel.text = "Today: 0"
    todaysTotalLabel.font = UIFont.systemFont(ofSize: 24)
    todaysTotalLabel.numberOfLines = 1
    todaysTotalLabel.textAlignment = .left
    todaysTotalLabel.isHidden = true
    let todaysLabelConstraint = NSLayoutConstraint(
      item: todaysTotalLabel,
      attribute: .height,
      relatedBy: .equal,
      toItem: nil,
      attribute: .notAnAttribute,
      multiplier: 1,
      constant: 30
    )

    viewChartsButton.translatesAutoresizingMaskIntoConstraints = false
    viewChartsButton.setTitle("View data", for: .normal)
    viewChartsButton.backgroundColor = .white
    viewChartsButton.layer.cornerRadius = 25
    viewChartsButton.isHidden = true
    let buttonHeightConstraint = NSLayoutConstraint(
      item: viewChartsButton,
      attribute: .height,
      relatedBy: .equal,
      toItem: nil,
      attribute: .notAnAttribute,
      multiplier: 1,
      constant: 52
    )

    addEntryView.translatesAutoresizingMaskIntoConstraints = false
    addEntryView.isHidden = true
    let addEntryViewHeightConstraint = NSLayoutConstraint(
      item: addEntryView,
      attribute: .height,
      relatedBy: .equal,
      toItem: nil,
      attribute: .notAnAttribute,
      multiplier: 1,
      constant: 100
    )

    buttonHeightConstraint.priority = UILayoutPriority(rawValue: 999)
    heightConstraint.priority = UILayoutPriority(rawValue: 999)
    addEntryViewHeightConstraint.priority = UILayoutPriority(rawValue: 999)
    todaysLabelConstraint.priority = UILayoutPriority(rawValue: 999)
    NSLayoutConstraint.activate([heightConstraint, todaysLabelConstraint, addEntryViewHeightConstraint, buttonHeightConstraint])
  }

  func toggleCellState() {
    self.cellState = self.cellState == .expanded ? .collapsed : .expanded
    let isCollapsed = self.cellState == .collapsed

    UIView.animate(withDuration: 0.2, animations: {
      self.activityNameLabel.isHidden = false
      self.addEntryView.isHidden = isCollapsed
      self.todaysTotalLabel.isHidden = isCollapsed
      self.viewChartsButton.isHidden = isCollapsed
      self.setNeedsLayout()
      self.layoutIfNeeded()
    })
  }
}
