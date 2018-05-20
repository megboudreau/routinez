//
//  BarChartView.swift
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
  var data: BarChartData?

  let barChart: BarChartView = {
    let l = BarChartView()

    l.pinchZoomEnabled = false
    l.legend.enabled = false
    l.rightAxis.enabled = false
    l.chartDescription?.enabled = false

    // Left Axis formatting
    l.leftAxis.drawBottomYLabelEntryEnabled = true
    l.leftAxis.drawGridLinesEnabled = false
    l.leftAxis.labelFont = UIFont.boldSystemFont(ofSize: 12)
    l.leftAxis.labelTextColor = .black
    l.leftAxis.axisLineWidth = 1

    // Xaxis formatting
    l.xAxis.labelTextColor = .black
    l.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 12)
    l.xAxis.drawGridLinesEnabled = false
    l.xAxis.axisLineWidth = 1
    l.xAxis.labelPosition = .bottom

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
    dateFormatter.dateFormat = "dd"
    return dateFormatter
  }()

  init(activity: Activity, dateRange: LineChartDateRange = .day) {
    self.activity = activity
    self.dateRange = dateRange

    super.init(frame: .zero)

    addSubview(barChart)
    barChart.pinToSuperviewEdges()
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
      barChart.noDataText = "No values recorded yet \(self.dateRange.description)."
      barChart.noDataFont = UIFont.systemFont(ofSize: 24)
      barChart.noDataTextColor = .darkBluePigment
      return
    }

    var referenceTimeInterval: TimeInterval = 0
    if let minTimeInterval = (entries.map { $0.timestamp.timeIntervalSince1970 }).min() {
      referenceTimeInterval = minTimeInterval
    }

    let monthReferenceInterval = Calendar.current.dateInterval(of: .month, for: Date())?.start.timeIntervalSince1970

    let weekReferenceInterval = Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.start.timeIntervalSince1970

    if dateRange == .day {
      let xValuesNumberFormatter = ChartXAxisFormatter(
        referenceTimeInterval: referenceTimeInterval,
        dateFormatter: dateFormatter
      )
      barChart.xAxis.valueFormatter = xValuesNumberFormatter
    } else if dateRange == .week {
//      let xValuesNumberFormatter = WeekChartXAxisFormatter(
//      referenceTimeInterval: weekReferenceInterval!,
//      dateFormatter: weekDateFormatter
//      )
//      barChart.xAxis.valueFormatter = xValuesNumberFormatter
//      barChart.xAxis.labelRotationAngle = -90
    }

//    else {
//      let xValuesNumberFormatter = MonthChartXAxisFormatter(
//      referenceTimeInterval: monthReferenceInterval!,
//      dateFormatter: weekDateFormatter
//      )
//      BarChart.xAxis.valueFormatter = xValuesNumberFormatter
//    }

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

    barChart.xAxis.granularity = 1.0
    barChart.xAxis.setLabelCount(dataEntries.count, force: true)
    barChart.xAxis.axisMinimum = dataEntries.first?.x ?? 0
    barChart.xAxis.avoidFirstLastClippingEnabled = true

    let barChartDataSet = BarChartDataSet(values: dataEntries, label: activity.name)
//    barChartDataSet.setCircleColor(activity.color)
    barChartDataSet.setColor(activity.color.withAlphaComponent(0.7))
//    barChartDataSet.circleHoleRadius = 0
//    barChartDataSet.circleRadius = 4
//    barChartDataSet.lineWidth = 2
    barChartDataSet.valueTextColor = .black

//    barChartDataSet.fill = Fill.fillWithCGColor(activity.color.cgColor)
//    barChartDataSet.drawFilledEnabled = true

    let data = BarChartData()
    data.addDataSet(barChartDataSet)

    self.data = data
  }

  func dataEntriesForDay(sortedEntries: [Entry], referenceTimeInterval: TimeInterval) -> [BarChartDataEntry] {
    var dataEntries = [BarChartDataEntry]()
    for entry in sortedEntries {
      let timeInterval = entry.timestamp.timeIntervalSince1970
      let xValue = (timeInterval - referenceTimeInterval)
      let yValue = entry.value
      let entry = BarChartDataEntry(x: xValue, y: Double(yValue))
      dataEntries.append(entry)
    }
    return dataEntries
  }

  func dataEntriesForWeek(sortedEntries: [Entry], referenceTimeInterval: TimeInterval) -> [BarChartDataEntry] {
    var dataEntries = [BarChartDataEntry]()

    var values = [(Double, Int)]()
    for index in 1...7 {
      let total = (sortedEntries.filter({ $0.timestamp.weekdayNumber == index }).map({ $0.value }).reduce(0, +))

      let calendar = Calendar.current
      let weekInterval = Calendar.current.dateInterval(of: .weekOfYear, for: Date())
      if let startDate = weekInterval?.start,
        let weekDay = calendar.date(byAdding: .weekday, value: index-1, to: startDate) {
        values.append((Double(weekDay.dayNumber), total))
      }
    }

    for value in values {
      let xValue = value.0
      let yValue = value.1
      let entry = BarChartDataEntry(x: xValue, y: Double(yValue))
      dataEntries.append(entry)
    }
    return dataEntries
  }

  func dataEntriesForMonth(sortedEntries: [Entry], referenceTimeInterval: TimeInterval) -> [BarChartDataEntry] {
    var dataEntries = [BarChartDataEntry]()

    var values = [(Double, Int)]()
    for index in 1...4 {
      let total = (sortedEntries.filter({ $0.timestamp.weekNumber == index }).map({ $0.value }).reduce(0, +))

      values.append((Double(index), total))
    }

    for value in values {
      let xValue = value.0
      let yValue = value.1
      let entry = BarChartDataEntry(x: xValue, y: Double(yValue))
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

    let weekInterval = Calendar.current.dateInterval(of: .weekOfMonth, for: date.addingTimeInterval(2.days))
    guard let startDate =  weekInterval?.start,
      let endDate = weekInterval?.end.addingTimeInterval(-1.day) else {
        return ""
    }
    let startDateString = dateFormatter.string(from: startDate)
    let endDateString = dateFormatter.string(from: endDate)
    return "\(startDateString) -\n\(endDateString)"
  }
}

class WeekChartXAxisFormatter: NSObject {
  var dateFormatter: DateFormatter
  var referenceTimeInterval: TimeInterval


  init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
    self.referenceTimeInterval = referenceTimeInterval
    self.dateFormatter = dateFormatter
  }
}

extension WeekChartXAxisFormatter: IAxisValueFormatter {

  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    let date = Date(timeIntervalSince1970: value + referenceTimeInterval)

    return dateFormatter.string(from: date.addingTimeInterval(1.day))
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
