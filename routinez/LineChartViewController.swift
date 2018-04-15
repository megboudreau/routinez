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

}

class LineChartViewController: UIViewController {

  var lineChartView: LineChart
  var activity: Activity
  var dateRange: LineChartDateRange
  let dateBanner = UILabel()
  let totalLabel = UILabel()

  init(activity: Activity, dateRange: LineChartDateRange = .day) {
    self.activity = activity
    self.dateRange = dateRange
    lineChartView = LineChart(activity: activity, dateRange: dateRange)

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    dateBanner.textColor = .darkBluePigment
    dateBanner.font = UIFont.boldSystemFont(ofSize: 24)
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

    setTotalForDateRange(activity: activity, dateRange: dateRange)
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

  func setTotalForDateRange(activity: Activity, dateRange: LineChartDateRange) {
    var total: Int = 0
    switch dateRange {
    case .day:
      total = Entries.sharedInstance.totalDailyValue(for: activity)
    case .week:
      total = Entries.sharedInstance.totalWeeklyValue(for: activity)
    case .month:
      total = Entries.sharedInstance.totalMonthlyValue(for: activity)
    }

    totalLabel.text = activity.isBoolValue ? "\(activity.name) \(dateRange.description): \(Bool(total))" : "\(activity.name) \(dateRange.description): \(total)"
  }

  func dateString(for dateRange: LineChartDateRange) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    let calendar = Calendar.current

    switch dateRange {
    case .day:
      return formatter.string(from: Date())
    case .week:
      let weekInterval = calendar.dateInterval(of: .weekOfYear, for: Date())
      guard let startDate = weekInterval?.start,
        let endDate = weekInterval?.end.addingTimeInterval(-1.day) else {
          return ""
      }
      let startDateString = formatter.string(from: startDate)
      let endDateString = formatter.string(from: endDate)
      return "\(startDateString) - \(endDateString)"
    case .month:
      let monthInterval = calendar.dateInterval(of: .month, for: Date())
      guard let startDate =  monthInterval?.start,
        let endDate = monthInterval?.end.addingTimeInterval(-1.day) else {
          return ""
      }
      let startDateString = formatter.string(from: startDate)
      let endDateString = formatter.string(from: endDate)
      return "\(startDateString) - \(endDateString)"
    }
  }
}
