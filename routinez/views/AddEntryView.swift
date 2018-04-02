//
//  AddEntryView.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-04-01.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

class AddEntryView: UIView {

  let addEntryLabel = UILabel()
  let addEntryPickerView = UIPickerView()
  let saveButton = UIButton()
  var selectedValue: Int = 0
  var newEntrySaved: (() -> Void)?

  var activity: Activity? {
    didSet {
      updateViews()
    }
  }

  var color: UIColor? {
    didSet {
      guard let color = color else {
        return
      }
      saveButton.backgroundColor = color
    }
  }

  init() {
    super.init(frame: .zero)

    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func commonInit() {
    addSubviewForAutoLayout(addEntryLabel)
    addSubviewForAutoLayout(saveButton)
    addSubviewForAutoLayout(addEntryPickerView)

    addEntryLabel.font = UIFont.systemFont(ofSize: 18)
    addEntryLabel.text = "Add a new entry: "
    addEntryLabel.textColor = .black
    addEntryLabel.sizeToFit()
    addEntryLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    addEntryLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

    addEntryPickerView.dataSource = self
    addEntryPickerView.delegate = self
    addEntryPickerView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    addEntryPickerView.leadingAnchor.constraint(equalTo: addEntryLabel.trailingAnchor, constant: 8).isActive = true
    addEntryPickerView.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -8).isActive = true
    addEntryPickerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
    saveButton.setTitle("Save", for: .normal)
    saveButton.setTitleColor(.white, for: .normal)
    saveButton.layer.cornerRadius = 18
    saveButton.backgroundColor = .plum
    saveButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    saveButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    saveButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    saveButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    updateViews()
  }

  func updateViews() {
    guard let activity = activity else {
      addEntryLabel.isHidden = true
      addEntryPickerView.isHidden = true
      saveButton.isHidden = true
      return
    }

    addEntryPickerView.isHidden = false
    addEntryLabel.isHidden = false
    saveButton.isHidden = false
    addEntryPickerView.reloadAllComponents()
  }

  @objc func didTapSave() {
    guard let activity = activity else {
      return
    }

    let entry = Entry(timestamp: Date(), value: selectedValue)
    Entries.sharedInstance.cacheNewEntry(entry, for: activity)
    saveButtonFlashTitle()
    newEntrySaved?()
  }

  func saveButtonFlashTitle() {
    saveButton.setTitle("Saving...", for: .normal)
    delay(1) {
      self.saveButton.setTitle("Success!", for: .normal)
      self.delay(1) {
        self.saveButton.setTitle("Save", for: .normal)
      }
    }
  }

  func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
      deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
  }
}

extension AddEntryView: UIPickerViewDataSource, UIPickerViewDelegate {

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    guard let activity = self.activity else {
      return 100
    }
    return activity.isBoolValue ? 2 : 100
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    guard let activity = activity else {
      return
    }

    self.selectedValue = activity.isBoolValue ? row : row * 10

  }

  func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    var text = "\(row * 10)"

    if let activity = activity,
      activity.isBoolValue {
      text = row == 0 ? "false" : "true"
    }

    let textColor: UIColor = self.color != nil ? color! : UIColor.plum
    return NSAttributedString(
      string: text,
      attributes: [
        NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18),
        NSAttributedStringKey.foregroundColor: textColor])
  }

}
