//
//  ItemsViewController.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/3/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import UIKit
import Reusable

protocol ItemsViewControllerOutput: ItemsModelInput {}
protocol ItemsViewControllerInput: ItemsModelOutput {}

class ItemsViewController: UIViewController, BarButtonCustomable {

  @IBOutlet fileprivate weak var tableView: UITableView!

  var model: ItemsViewControllerOutput!
  weak var output: ItemsModelOutput!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    setupTableView()
    model.reloadItems(update: false)
  }
  
}

fileprivate extension ItemsViewController {
  
  func setupViews() {
    navigationController?.navigationBar.flat = true
    navigationItem.backBarButtonItem = buttonWithoutTitle
    navigationItem.title = L10n.itemsTitle
  }
  
  func setupTableView() {
    tableView.register(cellType: ItemTableViewCell.self)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 64
    tableView.tableFooterView = UIView()
  }
  
  func handleEmptyState(_ numberOfItems: Int) {
    if numberOfItems == 0 {
      let placeholderView = PlaceholderView.loadFromNib()
      tableView.backgroundView = placeholderView
      placeholderView.title = L10n.itemsPlacheholderNoSavedItemsText
      placeholderView.image = Asset.Common.itemsPlaceholder.image
    } else {
      tableView.backgroundView = nil
    }
  }
  
}

extension ItemsViewController: ItemsViewControllerInput {

  func didUpdateStorage() {
    if tableView != nil {
      DispatchQueue.main.async {
        self.tableView.reloadData()
        self.handleEmptyState(self.model.numberOfItems())
      }
    }
  }
  
}

extension ItemsViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numberOfItems = model.numberOfItems()
    handleEmptyState(numberOfItems)
    return numberOfItems
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ItemTableViewCell.self)
    cell.сonfigure(with: model.item(at: indexPath.row))
    return cell
  }
}

extension ItemsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    model.openItemDetails(at: indexPath.row)
  }

}
