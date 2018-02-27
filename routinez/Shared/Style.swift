//
//  Style.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-19.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

class ThemeManager {

  static func applyTheme() {
    let tabBar = UITabBar.appearance()
    tabBar.backgroundImage = UIImage()
    tabBar.tintColor = .clear
    tabBar.shadowImage = UIImage()

    let navigationBar = UINavigationBar.appearance()
    navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationBar.shadowImage = UIImage()
  }

}

extension UIColor {

  static var teal = UIColor(red:0.02, green:0.74, blue:0.74, alpha:1.0)
  static var chartGrey = UIColor(red:0.93, green:0.91, blue:0.91, alpha:1.0)
  static var plum = UIColor(red:0.39, green:0.38, blue:0.89, alpha:1.0)
  static var chartBlue1 = UIColor(red:0.01, green:0.62, blue:0.87, alpha:1.0)
  static var chartBlue8 = UIColor(red:0.01, green:0.62, blue:0.83, alpha:1.0)
  static var chartBlue3 = UIColor(red:0.01, green:0.62, blue:0.79, alpha:1.0)
  static var chartBlue7 = UIColor(red:0.01, green:0.62, blue:0.75, alpha:1.0)
  static var chartBlue5 = UIColor(red:0.01, green:0.62, blue:0.71, alpha:1.0)
  static var chartBlue10 = UIColor(red:0.01, green:0.62, blue:0.67, alpha:1.0)
  static var chartBlue4 = UIColor(red:0.01, green:0.62, blue:0.63, alpha:1.0)
  static var chartBlue2 = UIColor(red:0.37, green:0.76, blue:0.92, alpha:1.0)
  static var chartBlue9 = UIColor(red:0.49, green:0.80, blue:0.93, alpha:1.0)
  static var chartBlue6 = UIColor(red:0.61, green:0.85, blue:0.95, alpha:1.0)


  static var bubblegum = UIColor(red:1.00, green:0.39, blue:0.58, alpha:1.0)
  static var tangerine = UIColor(red:1.00, green:0.59, blue:0.43, alpha:1.0)
  static var lightBlue = UIColor(red:0.37, green:0.74, blue:0.91, alpha:1.0)
  static var banana = UIColor(red:1.00, green:0.84, blue:0.43, alpha:1.0)
  static var fuschia = UIColor(red:0.79, green:0.38, blue:0.82, alpha:1.0)
  static var cherry = UIColor(red:0.92, green:0.24, blue:0.33, alpha:1.0)
  static var duskBlue = UIColor(red:0.30, green:0.34, blue:0.90, alpha:1.0)
  static var lightTeal = UIColor(red:0.40, green:0.84, blue:0.83, alpha:1.0)
  static var darkTeal = UIColor(red:0.06, green:0.62, blue:0.60, alpha:1.0)
  static var mutedPurple = UIColor(red:0.60, green:0.49, blue:0.80, alpha:1.0)
}
