//
//  DailyCircleChart.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-19.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit
import Charts

class DailyCircleChart: UIView {

  var chartValueSelected: ((String) -> Void)?
  var chartNothingSelected: (() -> Void)?
  var valueSelected: Bool = false

  let pieChart: PieChartView = {
    let p = PieChartView()
    p.legend.enabled = false
    p.chartDescription?.enabled = false
    p.holeRadiusPercent = 0.70

    p.noDataFont = UIFont.systemFont(ofSize: 18)
    p.noDataTextColor = .black

    return p
  }()

  var entryKeys: [String] {
    return Entries.sharedInstance.activityKeys ?? []
  }

  init() {
    super.init(frame: .zero)

    pieChart.delegate = self
    backgroundColor = .clear
    drawChart()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func drawChart() {
    addSubview(pieChart)
    pieChart.clipsToBounds = false
    pieChart.layer.masksToBounds = false
    pieChart.pinToSuperviewEdges()
  }

  func fillChart(animate: Bool = true) {
    guard !entryKeys.isEmpty else {
      pieChart.noDataText = "Add an activity to start tracking!"
      return
    }

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    let centerText = NSAttributedString(
      string: "Today's\ndata",
      attributes: [
        NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30),
        NSAttributedStringKey.foregroundColor: UIColor.plum,
        NSAttributedStringKey.paragraphStyle: paragraphStyle])
    pieChart.centerAttributedText = centerText

    var dataEntries = [PieChartDataEntry]()

    for key in entryKeys {
      let entry = PieChartDataEntry(value: Double(1), label: key)
      dataEntries.append(entry)
    }

    let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
    chartDataSet.colors = UIColor.activityColors
    chartDataSet.entryLabelColor = .black
    chartDataSet.entryLabelFont = UIFont.systemFont(ofSize: 12)
    chartDataSet.sliceSpace = 4
    chartDataSet.selectionShift = 10
    chartDataSet.drawValuesEnabled = false
    chartDataSet.xValuePosition = .outsideSlice
    chartDataSet.valueLineVariableLength = false
    chartDataSet.valueLineColor = .clear
    chartDataSet.valueLinePart1Length = 0.0
    chartDataSet.valueLinePart2Length = -0.15

    let chartData = PieChartData(dataSet: chartDataSet)
    pieChart.data = chartData
    pieChart.sizeToFit()

    if animate {
      pieChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
  }
}

extension DailyCircleChart: ChartViewDelegate {

  func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
    guard let entry = entry as? PieChartDataEntry,
    let entryName = entry.label else {
      return
    }
    valueSelected = true

    chartValueSelected?(entryName)
  }

  func chartValueNothingSelected(_ chartView: ChartViewBase) {
    valueSelected = false
    chartNothingSelected?()
  }
}
