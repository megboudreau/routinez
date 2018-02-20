//
//  UIViewExtensions.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-02-19.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

extension UIView {

  func addSubviewForAutoLayout(_ view: UIView) {
    addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false
  }

  @discardableResult public func pinAttributes(_ attributes: [NSLayoutAttribute], toView view: UIView, multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
    return self.pinAttributes(
      attributes,
      toView: view,
      multiplier: multiplier,
      insets: UIEdgeInsets(top: constant, left: constant, bottom: constant, right: constant)
    )
  }

  @discardableResult public func pinAttributes(_ attributes: [NSLayoutAttribute], toView view: UIView, multiplier: CGFloat = 1, insets: UIEdgeInsets) -> [NSLayoutConstraint] {

    translatesAutoresizingMaskIntoConstraints = false

    let invertedAttributes: [NSLayoutAttribute] = [.right,    .rightMargin,
                                                   .trailing, .trailingMargin,
                                                   .bottom,   .bottomMargin]

    let constraints = attributes.map({ (attribute) -> NSLayoutConstraint in

      let inverted = invertedAttributes.contains(attribute)
      let firstItem = inverted ? view : self
      let secondItem = inverted ? self : view
      let constant = attribute.value(for: insets)

      return NSLayoutConstraint(item: firstItem, attribute: attribute, relatedBy: .equal, toItem: secondItem, attribute: attribute, multiplier: multiplier, constant: constant)
    })
    NSLayoutConstraint.activate(constraints)
    return constraints
  }

  @discardableResult
  public func pinAspectRatio(heightToWidth: CGFloat = 1) -> NSLayoutConstraint {
    assert(heightToWidth > 0)
    let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: heightToWidth, constant: 0)
    constraint.isActive = true
    return constraint
  }

  @discardableResult
  public func pinToSuperviewEdges(with insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
    self.translatesAutoresizingMaskIntoConstraints = false

    let attributes: [NSLayoutAttribute] = [.top, .right, .bottom, .left]
    let constraints = attributes.map { attribute in
      pinAttributes([attribute], toView: superview!, multiplier: 1, insets: insets)
      }.joined()

    return Array(constraints)
  }

  var sizeConstraints: [NSLayoutConstraint] {
    return constraints.filter { $0.firstAttribute == .width || $0.firstAttribute == .height }
  }
}

extension UIImageView {

  @discardableResult
  func setLogoImage(_ image: UIImage?, installConstraints: Bool = true) -> (h: NSLayoutConstraint, w: NSLayoutConstraint)? {
    guard let image = image else {
      self.image = nil
      return nil
    }

    let maxSize = CGSize(width: 230.0, height: 50.0)
    let constrainedSize = CGSize(width: image.size.width, height: image.size.height)
    self.image = image

    let constrainToMax = image.size.height > maxSize.height || image.size.width > maxSize.width
    let size = constrainToMax ? maxSize : constrainedSize

    removeConstraints(sizeConstraints)
    return constrainToMaxSize(size)
  }

  @discardableResult
  func constrainToMaxSize(_ size: CGSize, automaticallyInstall: Bool = true) -> (h: NSLayoutConstraint, w: NSLayoutConstraint)? {
    guard let image = self.image else {
      return nil
    }

    let ratio = image.size.height / image.size.width
    let width = min(size.width, size.height / ratio)
    let height = width * ratio

    let widthConstraint = widthAnchor.constraint(equalToConstant: width)
    let heightConstraint = heightAnchor.constraint(equalToConstant: height)

    widthConstraint.isActive = automaticallyInstall
    heightConstraint.isActive = automaticallyInstall

    return (h: heightConstraint, w: widthConstraint)
  }

  @discardableResult
  func constrainToMaxHeight(_ maxHeight: CGFloat, automaticallyInstall: Bool = true) -> (h: NSLayoutConstraint, w: NSLayoutConstraint)? {
    return constrainToMaxSize(CGSize(width: -1, height: maxHeight))
  }
}

extension NSLayoutAttribute {
  func value(for insets: UIEdgeInsets) -> CGFloat {
    switch self {
    case .top, .topMargin:
      return insets.top
    case .right, .rightMargin, .trailing, .trailingMargin:
      return insets.right
    case .bottom, .bottomMargin:
      return insets.bottom
    case .left, .leftMargin, .leading, .leadingMargin:
      return insets.left
    default:
      return 0.0
    }
  }
}

