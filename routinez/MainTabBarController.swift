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

    tabBar.items?[0].imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
    tabBar.items?[1].imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)

    tabBar.tintColor = .plum
  }
}
