//
//  MainTabBarController.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-26.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()

    viewControllers = [
      ViewController(),
      ActivitiesViewController()
    ]

    let ringImage = UIImage(named: "ringIcon")
    let plusImage = UIImage(named: "addActivityIcon")

    tabBar.items?[0].image = ringImage
    tabBar.items?[1].image = plusImage

    tabBar.items?[0].title = "Data"
    tabBar.items?[1].title = "Add Activity"

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
