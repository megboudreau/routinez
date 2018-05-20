//
//  Style.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-19.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

extension UIWindow {

  func applyTheme() {
    let tabBar = UITabBar.appearance()
    tabBar.tintColor = .clear
    tabBar.shadowImage = UIImage()

    let barButtonItem = UIBarButtonItem.appearance()
    barButtonItem.tintColor = .darkGray

    backgroundColor = .white
  }
}

extension UITabBar {
  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    var sizeThatFits = super.sizeThatFits(size)
    sizeThatFits.height = 60
    if #available(iOS 11.0, *),
      let parent = superview {
      let bottomInset = parent.safeAreaInsets.bottom
      sizeThatFits.height += bottomInset
    }

    return sizeThatFits
  }
}
