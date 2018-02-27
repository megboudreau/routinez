//
//  LineChartViewController.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-22.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

enum LineChartDateRange {
  case day, week, month

  var description: String {
    switch self {
    case .day:
      return "today"
    case .week:
      return "this week"
    case .month:
      return "this month"
    }
  }

//  TODO
//  var dateRangeString: String
}

class LineChartViewController: UIViewController {

  var lineChartView: LineChart
  var entryName: String
  var dateRange: LineChartDateRange
  let dateBanner = DateBanner()
  let totalLabel = UILabel()

  init(entryName: String, dateRange: LineChartDateRange = .day) {
    self.entryName = entryName
    self.dateRange = dateRange
    lineChartView = LineChart(entryName: entryName, dateRange: dateRange)

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    view.addSubview(dateBanner)
    dateBanner.translatesAutoresizingMaskIntoConstraints = false
    dateBanner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    dateBanner.heightAnchor.constraint(equalToConstant: 50).isActive = true
    dateBanner.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
    if #available(iOS 11.0, *) {
      let safeArea = view.safeAreaLayoutGuide
      dateBanner.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16).isActive = true
    } else {
      dateBanner.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
    }

    let total = Entries.sharedInstance.totalDailyValueForEntry(entryName)
    totalLabel.text = "\(entryName): \(total)"
    totalLabel.font = UIFont.boldSystemFont(ofSize: 24)
    totalLabel.sizeToFit()
    view.addSubview(totalLabel)

    totalLabel.translatesAutoresizingMaskIntoConstraints = false
    totalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    totalLabel.topAnchor.constraint(equalTo: dateBanner.bottomAnchor).isActive = true

    view.addSubview(lineChartView)
    lineChartView.translatesAutoresizingMaskIntoConstraints = false
    lineChartView.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 24).isActive = true
    lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    lineChartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    lineChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
  }
}
