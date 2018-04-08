//
//  LineChartTabBarController.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-26.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

class LineChartTabBarController: UITabBarController {

  let activity: Activity

  init(activity: Activity) {
    self.activity = activity
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let dayImage = UIImage(named: "dayCalendar")
    let weekImage = UIImage(named: "weekCalendar")
    let monthImage = UIImage(named: "monthCalendar")

    if activity.isBoolValue {
      viewControllers = [
        LineChartViewController(activity: activity, dateRange: .week),
        LineChartViewController(activity: activity, dateRange: .month)
      ]

      tabBar.items?[0].image = weekImage
      tabBar.items?[1].image = monthImage

      tabBar.items?[0].title = "This Week"
      tabBar.items?[1].title = "This Month"

    } else {

      viewControllers = [
        LineChartViewController(activity: activity),
        LineChartViewController(activity: activity, dateRange: .week),
        LineChartViewController(activity: activity, dateRange: .month)
      ]

      tabBar.items?[0].image = dayImage
      tabBar.items?[1].image = weekImage
      tabBar.items?[2].image = monthImage

      tabBar.items?[0].title = "Today"
      tabBar.items?[1].title = "This Week"
      tabBar.items?[2].title = "This Month"
    }

    tabBar.tintColor = .plum
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()

    let topBorder = CALayer()
    let borderHeight: CGFloat = 1
    topBorder.borderWidth = borderHeight
    topBorder.borderColor = UIColor.gray.cgColor
    topBorder.frame = CGRect(x: 0, y: -1, width: tabBar.frame.width, height: borderHeight)
    tabBar.layer.addSublayer(topBorder)
  }
}
