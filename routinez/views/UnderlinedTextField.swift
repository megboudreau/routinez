//
//  UnderlinedTextField.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-03-25.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

class UnderlinedTextField: UITextField {

  var underlineView = UIView()
  private let insets: (x: CGFloat, y: CGFloat) = (12.0, 12.0)

  var underlineColor: UIColor = .darkBluePigment {
    didSet {
      underlineView.backgroundColor = underlineColor
    }
  }

  override init(frame: CGRect) {
    super.init(frame: .zero)

    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    commonInit()
  }

  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: insets.x, dy: 0.0)
  }

  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return textRect(forBounds: bounds)
  }

  func commonInit() {
    borderStyle = .none

    layer.borderColor = UIColor.clear.cgColor
    layer.borderWidth = 0

    background = nil
    backgroundColor = .clear
    layer.backgroundColor = UIColor.clear.cgColor

    autocapitalizationType = .sentences
    autocorrectionType = .default

    let height: CGFloat = intrinsicContentSize.height + insets.y * 2.0
    heightAnchor.constraint(equalToConstant: height).isActive = true

    addSubview(underlineView)
    underlineView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      underlineView.heightAnchor.constraint(equalToConstant: 2),
      underlineView.bottomAnchor.constraint(equalTo: bottomAnchor),
      underlineView.widthAnchor.constraint(equalTo: widthAnchor),
      underlineView.centerXAnchor.constraint(equalTo: centerXAnchor)
      ])
  }
}
