//
//  SearchViewController.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/3/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import UIKit
import Alamofire

protocol SearchViewControllerOutput: SearchModelInput {}
protocol SearchViewControllerInput: SearchModelOutput {}

final class SearchViewController: UIViewController, BarButtonCustomable {
  
  var model: SearchViewControllerOutput!
  
  @IBOutlet fileprivate weak var pickerView: UIPickerView!
  @IBOutlet fileprivate weak var searchItemTextField: InsetTextField!
  @IBOutlet fileprivate weak var searchItemTextFieldTopConstraint: NSLayoutConstraint!
  @IBOutlet fileprivate weak var searchButton: UIButton!
  
  // MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    subscribeToKeyboardsNotifications()
    setupViews()
    model.loadCategories()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if searchItemTextField.isFirstResponder {
      view.endEditing(true)
    } else {
      super.touchesBegan(touches, with: event)
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }

}

extension SearchViewController: SearchViewControllerInput {
  
  func didStartActivity() {
    DispatchQueue.main.async {
      self.showHud(with: L10n.searchHudStartLoadCategoriesText)
    }
  }
  
  func didFinishActivity(hasNewData: Bool) {
    DispatchQueue.main.async {
      self.hideHud(
        successStatus: L10n.searchHudEndLoadCategoriesText,
        completion: {
          if hasNewData {
            self.pickerView.reloadAllComponents()
          }
      })
    }
  }
  
  func didFinishActivity(error: Error) {
    DispatchQueue.main.async {
      self.hideHud(errorStatus: error.localizedDescription)
    }
  }
  
  func handleValidationError(_ validationError: String) {
    hideHud(errorStatus: validationError)
  }
  
}

fileprivate extension SearchViewController {
  
  func setupViews() {
    navigationController?.navigationBar.flat = true
    navigationItem.backBarButtonItem = buttonWithoutTitle
    navigationItem.title = L10n.searchTitle
    searchButton.setTitle(L10n.searchButtonTitle, for: .normal)
    searchButton.isEnabled = false
    searchItemTextField.placeholder = L10n.searchPlaceholderText
  }
  
  func subscribeToKeyboardsNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(SearchViewController.keyboardShown(_:)),
      name: UIResponder.keyboardDidShowNotification,
      object: nil
    )
  }
  
  @objc func keyboardShown(_ notification: Notification) {
    guard let userInfo = notification.userInfo as? [String : Any],
        let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
        return
    }
    
    let rawFrame = value.cgRectValue
    let keyboardFrame = view.convert(rawFrame, from: nil)
    
    if searchItemTextField.frame.maxY > keyboardFrame.minY {
      searchItemTextFieldTopConstraint.constant = keyboardFrame.height + 20
      UIView.animate(withDuration: 0.3, animations: {
        self.view.layoutIfNeeded()
      })
    }
  }
  
  @IBAction func searchButtonPressed(_ sender: Any) {
    model.searchItems()
  }
  
}

extension SearchViewController: UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return model.numberOfCategories()
  }
  
}

extension SearchViewController: UIPickerViewDelegate {
  
  func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    guard let category = model.category(at: row) else { return nil }
    
    let attributes = [
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20),
        NSAttributedString.Key.foregroundColor : UIColor(named: .mainTextColor),
      ]
    return NSAttributedString(string: category.longName, attributes: attributes)
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    model.selectCategory(at: row)
  }
  
}

extension SearchViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if let text = textField.text {
      searchButton.isEnabled = !text.isEmpty
      model.enteredText(text)
    }
    
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if let text = textField.text {
      searchButton.isEnabled = !text.isEmpty
      model.enteredText(text)
    }
  }
  
}

extension SearchViewController: UIGestureRecognizerDelegate {
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
}
