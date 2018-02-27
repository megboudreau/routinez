//
//  LineChartTabBarController.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-26.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

class LineChartTabBarController: UITabBarController {

  let entryName: String

  init(entryName: String) {
    self.entryName = entryName
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tabBar.backgroundColor = .white
    tabBar.backgroundImage = nil

    viewControllers = [
      LineChartViewController(entryName: entryName),
      LineChartViewController(entryName: entryName, dateRange: .week),
      LineChartViewController(entryName: entryName, dateRange: .month)
    ]

    let dayImage = UIImage(named: "deselectedDayCalendar")
    let daySelectedImage = UIImage(named: "dayCalendar")?.withRenderingMode(.alwaysOriginal)

    let weekImage = UIImage(named: "deselectedWeekCalendar")?.withRenderingMode(.alwaysOriginal)
    let weekSelectedImage = UIImage(named: "weekCalendar")?.withRenderingMode(.alwaysOriginal)

    let monthImage = UIImage(named: "deselectedMonthCalendar")?.withRenderingMode(.alwaysOriginal)
    let monthSelectedImage = UIImage(named: "monthCalendar")?.withRenderingMode(.alwaysOriginal)

    tabBar.items?[0].image = dayImage
    tabBar.items?[1].image = weekImage
    tabBar.items?[2].image = monthImage

    tabBar.items?[0].selectedImage = daySelectedImage
    tabBar.items?[1].selectedImage = weekSelectedImage
    tabBar.items?[2].selectedImage = monthSelectedImage
  }
}

extension UITabBar {
  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    var sizeThatFits = super.sizeThatFits(size)
    sizeThatFits.height = 60
    return sizeThatFits
  }
}
