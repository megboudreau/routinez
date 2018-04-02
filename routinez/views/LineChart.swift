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
    l.xAxis.avoidFirstLastClippingEnabled = true
    l.xAxis.drawGridLinesEnabled = false
    l.xAxis.axisLineWidth = 1

    return l
  }()

  lazy private var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    let calendar = Calendar(identifier: .gregorian)
    dateFormatter.locale = Locale.current
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
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
      // TODO
      // daily totals for the week
      entries = Entries.sharedInstance.entriesForWeek(activity)
    case .month:
      // TODO
      // weekly totals for each week 
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

    let xValuesNumberFormatter = ChartXAxisFormatter(
      referenceTimeInterval: referenceTimeInterval,
      dateFormatter: dateFormatter
    )

    lineChart.xAxis.valueFormatter = xValuesNumberFormatter
    lineChart.xAxis.granularity = 1.0 //
    lineChart.xAxis.labelCount = entries.count
    lineChart.xAxis.labelRotationAngle = -90

    // Define chart entries
    var dataEntries = [ChartDataEntry]()
    let sortedEntries = entries.sorted(by: { $0.timestamp.compare($1.timestamp) == .orderedAscending })
    for entry in sortedEntries {
      getDayOfWeek(todayDate: entry.timestamp)
      let timeInterval = entry.timestamp.timeIntervalSince1970
      let xValue = (timeInterval - referenceTimeInterval)
      let yValue = entry.value
      let entry = ChartDataEntry(x: xValue, y: Double(yValue))
      dataEntries.append(entry)
    }

    let lineChartDataSet = LineChartDataSet(values: dataEntries, label: activity.name)
    lineChartDataSet.circleColors = [UIColor.teal]
    lineChartDataSet.circleHoleRadius = 0
    lineChartDataSet.circleRadius = 4
    lineChartDataSet.lineWidth = 2
    lineChartDataSet.valueTextColor = .clear

    let gradientColours = [
      UIColor.teal.cgColor,
      UIColor.white.withAlphaComponent(0).cgColor
      ] as CFArray
    let colourLocations: [CGFloat] = [1, 0]
    if let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColours, locations: colourLocations) {
      lineChartDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
      lineChartDataSet.drawFilledEnabled = true
    }

    let data = LineChartData()
    data.addDataSet(lineChartDataSet)

    self.data = data
  }

  func getDayOfWeek(todayDate: Date) {
//
//    let formatter  = DateFormatter()
//    let myComponents = Calendar(identifier: .gregorian).component(.weekday, from: todayDate)
//    let weekDay = myComponents.day

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
