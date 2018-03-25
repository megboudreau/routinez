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
  let dateBanner = UILabel()
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

    dateBanner.textColor = .plum
    dateBanner.font = UIFont.systemFont(ofSize: 24)
    dateBanner.text = dateString(for: dateRange)
    dateBanner.adjustsFontSizeToFitWidth = true
    dateBanner.sizeToFit()
    view.addSubview(dateBanner)
    dateBanner.translatesAutoresizingMaskIntoConstraints = false
    dateBanner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    if #available(iOS 11.0, *) {
      let safeArea = view.safeAreaLayoutGuide
      dateBanner.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16).isActive = true
    } else {
      dateBanner.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
    }

    setTotalForDateRange(entryName: entryName, dateRange: dateRange)
    totalLabel.font = UIFont.systemFont(ofSize: 20)
    totalLabel.adjustsFontSizeToFitWidth = true
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

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    guard let data = lineChartView.data else {
      return
    }
    lineChartView.lineChart.data = data
    lineChartView.lineChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
  }

  func setTotalForDateRange(entryName: String, dateRange: LineChartDateRange) {
    switch dateRange {
    case .day:
      let total = Entries.sharedInstance.totalDailyValueForEntry(entryName)
      totalLabel.text = "\(entryName) for \(dateRange.description): \(total)"
    case .week:
      let total = Entries.sharedInstance.totalWeeklyValueForEntry(entryName)
      totalLabel.text = "\(entryName) for \(dateRange.description): \(total)"
    case .month:
      let total = Entries.sharedInstance.totalMonthlyValueForEntry(entryName)
      totalLabel.text = "\(entryName) for \(dateRange.description): \(total)"
    }
  }

  func dateString(for dateRange: LineChartDateRange) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    let calendar = Calendar.autoupdatingCurrent

    switch dateRange {
    case .day:
      return formatter.string(from: Date())
    case .week:
      let weekInterval = calendar.dateInterval(of: .weekOfYear, for: Date())
      guard let startDate = weekInterval?.start,
        let endDate = weekInterval?.end else {
          return ""
      }
      let startDateString = formatter.string(from: startDate)
      let endDateString = formatter.string(from: endDate)
      return "\(startDateString) - \(endDateString)"
    case .month:
      let monthInterval = calendar.dateInterval(of: .month, for: Date())
      guard let startDate =  monthInterval?.start,
        let endDate = monthInterval?.end else {
          return ""
      }
      let startDateString = formatter.string(from: startDate)
      let endDateString = formatter.string(from: endDate)
      return "\(startDateString) - \(endDateString)"
    }
  }
}