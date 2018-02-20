//
//  DailyCircleChart.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-19.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

// to consider https://stackoverflow.com/questions/41197122/pie-chart-using-charts-library-with-swift-3

class DailyCircleChart: UIView {

  var colours: [UIColor] = [
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

  var totalValues: CGFloat {
    return 10 // TODO return entry names .count
  }

  var maxValues: Int {
    return 10
  }

  init() {
    super.init(frame: .zero)

    backgroundColor = .white
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
    let entries = [1]
    drawChart(with: entries) // TODO get number of unique entry types
    drawCenterCircle()
  }

  func drawCenterCircle() {
    let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    let radius: CGFloat = bounds.width/4

    let path = UIBezierPath(
      arcCenter: center,
      radius: radius,
      startAngle: 0,
      endAngle: 2 * CGFloat.pi,
      clockwise: true
    )

    UIColor.white.setFill()
    path.fill()
  }

  // https://stackoverflow.com/questions/35388471/create-a-circle-with-multi-coloured-segments-in-core-graphics
  func drawChart(with entries: [Int]) {
    let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    let radius: CGFloat = bounds.width/2
    var angle: CGFloat = -CGFloat.pi/2

    let uniqueEntryCount = entries.count

    for index in 0...maxValues {
      let path = UIBezierPath()
      let value: CGFloat = 1 // just set this to any number to get even values

      let sliceAngle = CGFloat.pi * 2 * value/totalValues

      let fillColor = index > uniqueEntryCount ? UIColor.chartGrey : colours[index]
      fillColor.setFill()

      path.move(to: center)
      path.addArc(
        withCenter: center,
        radius: radius,
        startAngle: angle,
        endAngle: angle - sliceAngle,
        clockwise: false
      )
      path.move(to: center)
      path.close()
      path.fill()

      angle -= sliceAngle
    }
  }
}
