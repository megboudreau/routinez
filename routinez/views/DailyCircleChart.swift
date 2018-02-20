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

  var chartValueSelected: (() -> Void)?
  let chartColors: [UIColor] = [
    .chartGrey,
    .chartBlue1,
    .chartBlue2,
    .chartBlue3,
    .chartBlue4,
    .chartBlue5,
    .chartBlue6,
    .chartBlue7,
    .chartBlue8,
    .chartBlue9,
    .chartBlue10
  ]

  let pieChart: PieChartView = {
    let p = PieChartView()
    p.legend.enabled = false
    p.chartDescription?.enabled = false
    p.holeRadiusPercent = 0.65

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    let centerText = NSAttributedString(
      string: "Today's\ndata",
      attributes: [
        NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30),
        NSAttributedStringKey.foregroundColor: UIColor.plum,
        NSAttributedStringKey.paragraphStyle: paragraphStyle])
    p.centerAttributedText = centerText
    return p
  }()

  var entryKeys: [String] {
    return Entries.sharedInstance.sortedEntriesByName.map { $0.key }
  }

  init() {
    super.init(frame: .zero)

    pieChart.delegate = self
    backgroundColor = .white
    drawChart()
    fillChart()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func drawChart() {
    addSubview(pieChart)
    pieChart.pinToSuperviewEdges()
  }

  func fillChart(animate: Bool = true) {
    var dataEntries = [PieChartDataEntry]()

    for key in entryKeys {
      let total = Entries.sharedInstance.totalDailyValueForEntry(key)
      let label = "\(key): \(total)"
      let entry = PieChartDataEntry(value: Double(1), label: label)
      dataEntries.append(entry)
    }

    if entryKeys.isEmpty {
      dataEntries.append(PieChartDataEntry(value: Double(1), label: ""))
    }

    let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
    chartDataSet.colors = chartColors
    chartDataSet.sliceSpace = 0
    chartDataSet.selectionShift = 0
    chartDataSet.drawValuesEnabled = false

    let chartData = PieChartData(dataSet: chartDataSet)
    pieChart.data = chartData

    if animate {
      pieChart.animate(xAxisDuration: 1.3, yAxisDuration: 1.3)
    }
  }
}

extension DailyCircleChart: ChartViewDelegate {

  func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
    print("Selected")
    chartValueSelected?()
  }

}
