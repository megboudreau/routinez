//
//  LineChartView.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-21.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit
import Charts

class LineChart: UIView {

  let activity: Activity
  let dateRange: LineChartDateRange
  var data: LineChartData?

  let lineChart: LineChartView = {
    let l = LineChartView()

    l.pinchZoomEnabled = false
    l.legend.enabled = false
    l.rightAxis.enabled = false
    l.chartDescription?.enabled = false

    // Left Axis formatting
    l.leftAxis.drawBottomYLabelEntryEnabled = true
    l.leftAxis.drawGridLinesEnabled = false
    l.leftAxis.labelFont = UIFont.boldSystemFont(ofSize: 12)
    l.leftAxis.labelTextColor = .plum
    l.leftAxis.axisLineWidth = 1

    // Xaxis formatting
    l.xAxis.labelTextColor = .plum
    l.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 12)
    l.xAxis.drawGridLinesEnabled = false
    l.xAxis.axisLineWidth = 1

    return l
  }()

  lazy private var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.calendar = Calendar.current
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    return dateFormatter
  }()

  lazy private var weekDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.calendar = Calendar.current
    dateFormatter.dateFormat = "MMM dd"
    return dateFormatter
  }()

  init(activity: Activity, dateRange: LineChartDateRange = .day) {
    self.activity = activity
    self.dateRange = dateRange

    super.init(frame: .zero)

    addSubview(lineChart)
    lineChart.pinToSuperviewEdges()
    drawChart()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func drawChart() {

    var entries: [Entry]
    switch dateRange {
    case .day:
      entries = Entries.sharedInstance.entriesForDay(activity)
    case .week:
      entries = Entries.sharedInstance.entriesForWeek(activity)
    case .month:
      entries = Entries.sharedInstance.entriesForMonth(activity)
    }

    guard entries.count > 0 else {
      lineChart.noDataText = "No values recorded yet \(self.dateRange.description)."
      lineChart.noDataFont = UIFont.systemFont(ofSize: 24)
      lineChart.noDataTextColor = .plum
      return
    }

    var referenceTimeInterval: TimeInterval = 0
    if let minTimeInterval = (entries.map { $0.timestamp.timeIntervalSince1970 }).min() {
      referenceTimeInterval = minTimeInterval
    }

    let monthReferenceInterval = Calendar.current.dateInterval(of: .month, for: Date())?.start.timeIntervalSince1970

    let weekReferenceInterval = Calendar.current.dateInterval(of: .weekOfMonth, for: Date())?.start.timeIntervalSince1970

    if dateRange == .day {
      let xValuesNumberFormatter = ChartXAxisFormatter(
        referenceTimeInterval: referenceTimeInterval,
        dateFormatter: dateFormatter
      )
      lineChart.xAxis.valueFormatter = xValuesNumberFormatter
    } else if dateRange == .week {
      let xValuesNumberFormatter = ChartXAxisFormatter(
      referenceTimeInterval: weekReferenceInterval!,
      dateFormatter: weekDateFormatter
      )
      lineChart.xAxis.valueFormatter = xValuesNumberFormatter
    } else {
      let xValuesNumberFormatter = MonthChartXAxisFormatter(
      referenceTimeInterval: monthReferenceInterval!,
      dateFormatter: weekDateFormatter
      )
      lineChart.xAxis.valueFormatter = xValuesNumberFormatter
    }

    // Define chart entries
    let sortedEntries = entries.sorted(by: { $0.timestamp.compare($1.timestamp) == .orderedAscending })

    var dataEntries: [ChartDataEntry]
    switch dateRange {
    case .day:
      dataEntries = dataEntriesForDay(
        sortedEntries: sortedEntries,
        referenceTimeInterval: referenceTimeInterval)
    case .week:
      dataEntries = dataEntriesForWeek(
        sortedEntries: sortedEntries,
        referenceTimeInterval: referenceTimeInterval)
    case .month:
      dataEntries = dataEntriesForMonth(
        sortedEntries: sortedEntries,
        referenceTimeInterval: referenceTimeInterval)
    }

    lineChart.xAxis.granularity = 1.0
//    lineChart.xAxis.labelRotationAngle = -45
    lineChart.xAxis.labelCount = dataEntries.count
    lineChart.xAxis.axisMinimum = -1
//    if let lastEntry = dataEntries.last {
//      lineChart.xAxis.axisMaximum = lastEntry.x + TimeInterval(1.day)
//    }

    let lineChartDataSet = LineChartDataSet(values: dataEntries, label: activity.name)
    lineChartDataSet.circleColors = [UIColor.teal]
    lineChartDataSet.circleHoleRadius = 0
    lineChartDataSet.circleRadius = 4
    lineChartDataSet.lineWidth = 2
    lineChartDataSet.valueTextColor = .clear

    let data = LineChartData()
    data.addDataSet(lineChartDataSet)

    self.data = data
  }

  func dataEntriesForDay(sortedEntries: [Entry], referenceTimeInterval: TimeInterval) -> [ChartDataEntry] {
    var dataEntries = [ChartDataEntry]()
    for entry in sortedEntries {
      let timeInterval = entry.timestamp.timeIntervalSince1970
      let xValue = (timeInterval - referenceTimeInterval)
      let yValue = entry.value
      let entry = ChartDataEntry(x: xValue, y: Double(yValue))
      dataEntries.append(entry)
    }
    return dataEntries
  }

  func dataEntriesForWeek(sortedEntries: [Entry], referenceTimeInterval: TimeInterval) -> [ChartDataEntry] {
    var dataEntries = [ChartDataEntry]()

    var values = [(TimeInterval, Int)]()
    for index in 1...8 {
      let total = (sortedEntries.filter({ $0.timestamp.weekdayNumber == index }).map({ $0.value }).reduce(0, +))

      let calendar = Calendar.current
      if let weekDay = calendar.date(byAdding: .weekday, value: index-1, to: Date()) {
        values.append((weekDay.timeIntervalSince1970, total))
      }
    }

    for value in values {
      let timeInterval = value.0
      let xValue = (timeInterval - referenceTimeInterval)
      let yValue = value.1
      let entry = ChartDataEntry(x: xValue, y: Double(yValue))
      dataEntries.append(entry)
    }
    return dataEntries
  }

  func dataEntriesForMonth(sortedEntries: [Entry], referenceTimeInterval: TimeInterval) -> [ChartDataEntry] {
    var dataEntries = [ChartDataEntry]()

    var values = [(TimeInterval, Int)]()
    for index in 1...4 {
      let total = (sortedEntries.filter({ $0.timestamp.weekNumber == index }).map({ $0.value }).reduce(0, +))

      let calendar = Calendar.current
      if let week = calendar.date(byAdding: .weekOfMonth, value: index-1, to: Date()) {
        values.append((week.timeIntervalSince1970, total))
      }
    }

    for value in values {
      let timeInterval = value.0
      let xValue = (timeInterval - referenceTimeInterval)
      let yValue = value.1
      let entry = ChartDataEntry(x: xValue, y: Double(yValue))
      dataEntries.append(entry)
    }
    return dataEntries
  }
}

class MonthChartXAxisFormatter: NSObject {
  var dateFormatter: DateFormatter
  var referenceTimeInterval: TimeInterval


  init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
    self.referenceTimeInterval = referenceTimeInterval
    self.dateFormatter = dateFormatter
  }
}

extension MonthChartXAxisFormatter: IAxisValueFormatter {

  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    let date = Date(timeIntervalSince1970: value + referenceTimeInterval)

    let weekInterval = Calendar.current.dateInterval(of: .weekOfMonth, for: date)
    guard let startDate =  weekInterval?.start,
      let endDate = weekInterval?.end else {
        return ""
    }
    let startDateString = dateFormatter.string(from: startDate)
    let endDateString = dateFormatter.string(from: endDate)
    return "\(startDateString) -\n\(endDateString)"
  }
}

class ChartXAxisFormatter: NSObject {
  var dateFormatter: DateFormatter
  var referenceTimeInterval: TimeInterval


  init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
    self.referenceTimeInterval = referenceTimeInterval
    self.dateFormatter = dateFormatter
  }
}

extension ChartXAxisFormatter: IAxisValueFormatter {

  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    let date = Date(timeIntervalSince1970: value + referenceTimeInterval)
    return dateFormatter.string(from: date)
  }
}
