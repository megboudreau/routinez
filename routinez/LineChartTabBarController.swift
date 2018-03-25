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

    viewControllers = [
      LineChartViewController(activity: activity),
      LineChartViewController(activity: activity, dateRange: .week),
      LineChartViewController(activity: activity, dateRange: .month)
    ]

    let dayImage = UIImage(named: "dayCalendar")
    let weekImage = UIImage(named: "weekCalendar")
    let monthImage = UIImage(named: "monthCalendar")

    tabBar.items?[0].image = dayImage
    tabBar.items?[1].image = weekImage
    tabBar.items?[2].image = monthImage

    tabBar.items?[0].imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
    tabBar.items?[1].imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
    tabBar.items?[2].imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)

    tabBar.tintColor = .plum
  }
}
