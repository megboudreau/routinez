//
//  CreateActivityViewController.swift
//  routinez
//
//  Created by Megan Boudreau on 2018-03-25.
//  Copyright © 2018 Megan Boudreau. All rights reserved.
//

import UIKit

class CreateActivityViewController: UIViewController {

  let plusIcon = UIImageView(image: UIImage(named: "addActivityIcon"))
  let nameLabel = UILabel()
  let nameTextField = UnderlinedTextField()
  let isBoolValueLabel = UILabel()
  let isBoolValueSubLabel = UILabel()
  let isBoolValueSwitch = UISwitch()
  let isDefaultValueLabel = UILabel()
  let isDefaultValueSubLabel = UILabel()
  let isDefaultValueSwitch = UISwitch()
  let unitOfMeasurementLabel = UILabel()
  let unitLabel = UILabel()
  let unitOfMeasurementPickerView = UIPickerView()
  let color: UIColor
  let saveButton = UIButton()

  // MARK - Activity Stuff
  var isBoolValue: Bool = false
  var isDefaultValue: Bool = false
  var selectedUnit: Unit = .noUnit {
    didSet {
      unitLabel.text = selectedUnit.rawValue
    }
  }

  init(color: UIColor) {
    self.color = color

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
    unitOfMeasurementPickerView.delegate = self
    unitOfMeasurementPickerView.dataSource = self

    nameTextField.underlineColor = color
    nameTextField.delegate = self

    addInitialViews()
  }

  func addInitialViews() {
    view.addSubviewForAutoLayout(plusIcon)
    view.addSubviewForAutoLayout(saveButton)
    view.addSubviewForAutoLayout(nameLabel)
    view.addSubviewForAutoLayout(nameTextField)
    view.addSubviewForAutoLayout(isBoolValueLabel)
    view.addSubviewForAutoLayout(isBoolValueSubLabel)
    view.addSubviewForAutoLayout(isBoolValueSwitch)
    view.addSubviewForAutoLayout(isDefaultValueSubLabel)
    view.addSubviewForAutoLayout(unitOfMeasurementLabel)
    view.addSubviewForAutoLayout(isDefaultValueSwitch)
    view.addSubviewForAutoLayout(unitOfMeasurementPickerView)
    view.addSubviewForAutoLayout(isDefaultValueLabel)
    view.addSubviewForAutoLayout(unitLabel)

    plusIcon.tintColor = color
    plusIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    plusIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
    plusIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
    if #available(iOS 11.0, *) {
      let safeArea = view.safeAreaLayoutGuide
      plusIcon.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16).isActive = true
    } else {
      plusIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
    }

    nameLabel.text = "Name: "
    nameLabel.font = UIFont.systemFont(ofSize: 24)
    nameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    nameLabel.sizeToFit()
    nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    nameLabel.topAnchor.constraint(equalTo: plusIcon.bottomAnchor, constant: 24).isActive = true

    nameTextField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    nameTextField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    nameTextField.delegate = self
    nameTextField.placeholder = "What would you like to track?"
    nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 4).isActive = true
    nameTextField.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true

    isBoolValueLabel.text = "Is this a true/false value?"
    isBoolValueLabel.font = UIFont.systemFont(ofSize: 24)
    isBoolValueLabel.sizeToFit()
    isBoolValueLabel.adjustsFontSizeToFitWidth = true
    isBoolValueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    isBoolValueLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 36).isActive = true

    isBoolValueSubLabel.text = "Ex: Went to gym"
    isBoolValueSubLabel.textColor = UIColor.darkGray
    isBoolValueSubLabel.font = UIFont.systemFont(ofSize: 12)
    isBoolValueSubLabel.sizeToFit()
    isBoolValueSubLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    isBoolValueSubLabel.topAnchor.constraint(equalTo: isBoolValueLabel.bottomAnchor, constant: 4).isActive = true

    isBoolValueSwitch.onTintColor = color
    isBoolValueSwitch.isOn = isBoolValue
    isBoolValueSwitch.addTarget(self, action: #selector(isBoolSwitchValueChanged), for: .valueChanged)
    isBoolValueSwitch.leadingAnchor.constraint(equalTo: isBoolValueLabel.trailingAnchor, constant: 4).isActive = true
    isBoolValueSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    isBoolValueSwitch.centerYAnchor.constraint(equalTo: isBoolValueLabel.centerYAnchor).isActive = true

    isDefaultValueLabel.text = "Is this a default Activity?"
    isDefaultValueLabel.font = UIFont.systemFont(ofSize: 24)
    isDefaultValueLabel.sizeToFit()
    isDefaultValueLabel.adjustsFontSizeToFitWidth = true
    isDefaultValueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    isDefaultValueLabel.topAnchor.constraint(equalTo: isBoolValueLabel.bottomAnchor, constant: 36).isActive = true

    isDefaultValueSubLabel.text = "This will be the value tracked on the watch complication"
    isDefaultValueSubLabel.textColor = .darkGray
    isDefaultValueSubLabel.font = UIFont.systemFont(ofSize: 12)
    isDefaultValueSubLabel.adjustsFontSizeToFitWidth = true
    isDefaultValueSubLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    isDefaultValueSubLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    isDefaultValueSubLabel.topAnchor.constraint(equalTo: isDefaultValueLabel.bottomAnchor, constant: 4).isActive = true

    isDefaultValueSwitch.onTintColor = color
    isDefaultValueSwitch.isOn = isDefaultValue
    isDefaultValueSwitch.isEnabled = !isBoolValue
    isDefaultValueSwitch.addTarget(self, action: #selector(isDefaultSwitchValueChanged), for: .valueChanged)
    isDefaultValueSwitch.leadingAnchor.constraint(equalTo: isDefaultValueLabel.trailingAnchor, constant: 4).isActive = true
    isDefaultValueSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    isDefaultValueSwitch.centerYAnchor.constraint(equalTo: isDefaultValueLabel.centerYAnchor).isActive = true

    unitOfMeasurementLabel.text = "Unit of measurement: "
    unitOfMeasurementLabel.font = UIFont.systemFont(ofSize: 24)
    unitOfMeasurementLabel.sizeToFit()
    unitOfMeasurementLabel.adjustsFontSizeToFitWidth = true
    unitOfMeasurementLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    unitOfMeasurementLabel.topAnchor.constraint(equalTo: isDefaultValueLabel.bottomAnchor, constant: 30).isActive = true

    unitLabel.text = "no unit"
    unitLabel.textColor = color
    unitLabel.font = UIFont.systemFont(ofSize: 24)
    unitLabel.sizeToFit()
    unitLabel.leadingAnchor.constraint(equalTo: unitOfMeasurementLabel.trailingAnchor, constant: 4).isActive = true
    unitLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    unitLabel.centerYAnchor.constraint(equalTo: unitOfMeasurementLabel.centerYAnchor).isActive = true

    unitOfMeasurementPickerView.topAnchor.constraint(equalTo: unitLabel.bottomAnchor, constant: 6).isActive = true
    unitOfMeasurementPickerView.leadingAnchor.constraint(equalTo: unitOfMeasurementLabel.trailingAnchor, constant: 4)
    unitOfMeasurementPickerView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -6).isActive = true
    unitOfMeasurementPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    saveButton.setTitle("Save", for: .normal)
    saveButton.setTitleColor(.white, for: .normal)
    saveButton.backgroundColor = color
    saveButton.layer.cornerRadius = 25
    saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)

    saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    saveButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor, constant: -16).isActive = true
    saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true 
  }

  @objc func didTapSave(_ sender: UIButton) {
    guard let name = nameTextField.text,
     !name.isEmpty else {
      return
    }

    let activity = Activity(name: name, isBoolValue: isBoolValue, unitOfMeasurement: selectedUnit, isDefault: isDefaultValue)
    Entries.sharedInstance.cacheNewActivity(activity)

    ActivitiesViewController.activities = nil
    navigationController?.popViewController(animated: true)
  }

  @objc func isBoolSwitchValueChanged(switchState: UISwitch) {
    isBoolValue = switchState.isOn
    isDefaultValueSwitch.isEnabled = !isBoolValue
  }

  @objc func isDefaultSwitchValueChanged(switchState: UISwitch) {
    isDefaultValue = switchState.isOn
  }
}

extension CreateActivityViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {

    dismissKeyboard()
    return true
  }

  func dismissKeyboard() {
    nameTextField.endEditing(true)
  }
}

extension CreateActivityViewController: UIPickerViewDelegate, UIPickerViewDataSource {

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return Unit.allUnits[row].rawValue
  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return Unit.allUnits.count
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedUnit = Unit.allUnits[row]
  }
}
