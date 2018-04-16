//
//  LaunchViewController.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-04-15.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

  let chartImageView = UIImageView(image: UIImage(named: "chart"))

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .darkBluePigment
    view.addSubviewForAutoLayout(chartImageView)

    chartImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    chartImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    chartImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    chartImageView.widthAnchor.constraint(equalToConstant: 82).isActive = true

    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor.clear, UIColor.black.cgColor]
    gradientLayer.locations = [0.0, 0.7]
    gradientLayer.frame = self.view.bounds

    self.view.layer.insertSublayer(gradientLayer, at: 0)

    delay(2, closure: {
      let navController = UINavigationController(rootViewController: MainTabBarController())
      navController.modalTransitionStyle = .crossDissolve
      navController.modalPresentationStyle = .overCurrentContext

      self.view.backgroundColor = .white
      gradientLayer.removeFromSuperlayer()
      self.present(navController, animated: true, completion: nil)
    })

      // Do any additional setup after loading the view.
  }

  func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
      deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
  }

}
