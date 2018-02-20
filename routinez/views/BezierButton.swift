//
//  BezierButton.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-19.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

class BezierButton: UIButton {

  var path: UIBezierPath

  init(path: UIBezierPath) {
    self.path = path
    
    super.init(frame: .zero)

    addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {

    
  }

  @objc func didTapButton() {
    print("BUTTON TAPPED")
  }
}
