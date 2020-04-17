//
//  DetailsViewController.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/3/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import UIKit
import SDWebImage

protocol DetailsViewControllerOutput: DetailsModelInput {}
protocol DetailsViewControllerInput: DetailsModelOutput {}

class DetailsViewController: UIViewController, BarButtonCustomable {
  
  var model: DetailsViewControllerOutput!
  
  @IBOutlet fileprivate weak var loadSpinner: UIActivityIndicatorView!
  @IBOutlet fileprivate weak var itemImageView: UIImageView!
  @IBOutlet fileprivate weak var itemTitleLabel: UILabel!
  @IBOutlet fileprivate weak var itemPriceLabel: UILabel!
  @IBOutlet fileprivate weak var itemDescriptionTextView: UITextView!
  @IBOutlet fileprivate weak var topConstraintItemDescriptionTextView: NSLayoutConstraint!
  
  // MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    model.getItemDetails()
    model.getItemImageUrl()
    setupNavigationBar()
  }
  
}

fileprivate extension DetailsViewController {
  
  func setupViews() {
    loadSpinner.hidesWhenStopped = true
  }
  
  func setupNavigationBar() {
    navigationItem.backBarButtonItem = buttonWithoutTitle
    navigationItem.title = L10n.detailsTitle
    
    let isStored = model.isStoredItem()
    
    let barButton = UIBarButtonItem(
      image: isStored ? Asset.NavigationBar.deleteBarButton.image : Asset.NavigationBar.addBarButton.image,
      style: .plain,
      target: self,
      action: isStored ? #selector(DetailsViewController.removeItem) : #selector(DetailsViewController.addItem)
    )
    navigationItem.rightBarButtonItem = barButton
  }
  
  func updateDescriptionTextViewConstraint() {
    let size = CGSize(width: itemDescriptionTextView.frame.width, height: CGFloat.greatestFiniteMagnitude)
    topConstraintItemDescriptionTextView.constant = itemDescriptionTextView.sizeThatFits(size).height
  }
  
  @objc func addItem() {
    model.addItemInDataBase()
  }
  
  @objc func removeItem() {
    model.removeItemFromDataBase()
  }
  
}

extension DetailsViewController: DetailsViewControllerInput {
  
  func didPrepareDisplayableItem(_ item: DetailsModel.DisplayableItem) {
    itemTitleLabel.text = item.title.capitalized
    itemPriceLabel.text = "\(item.currencyCode) \(item.price)"
    itemDescriptionTextView.text = item.itemDescription
    
    updateDescriptionTextViewConstraint()
  }
  
  func didStartActivity() {
    DispatchQueue.main.async {
      self.loadSpinner.startAnimating()
    }
  }
  
  func didFinishActivity(hasNewData: Bool) {
    DispatchQueue.main.async {
      self.loadSpinner.stopAnimating()
    }
  }
  
  func didFinishActivity(error: Error) {
    DispatchQueue.main.async {
      self.showErrorHud(with: error.localizedDescription, completion: {
        self.loadSpinner.stopAnimating()
      })
    }
  }
  
  func didPrepareItemImageUrl(_ url: URL?) {
    itemImageView.sd_setImage(with: url)
  }
  
  func didSaveItem() {
    DispatchQueue.main.async {
      self.showSuccessHud(with: L10n.detailsHudSuccessSaveItemText)
    }
  }
  
  func didRemoveItem() {
    DispatchQueue.main.async {
      self.showSuccessHud(
        with: L10n.detailsHudSuccessRemoveItemText,
        completion: {
          let _ = self.navigationController?.popViewController(animated: true)
      })
    }
  }
  
  func didFailItemAction(error: Error) {
    DispatchQueue.main.async {
      self.showErrorHud(with: error.localizedDescription)
    }
  }
  
}
