//
//  ItemTableViewCell.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/6/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import UIKit
import Reusable

final class ItemTableViewCell: UITableViewCell, NibReusable {
  
  @IBOutlet fileprivate weak var itemNameLabel: UILabel!
  @IBOutlet fileprivate weak var itemPriceLabel: UILabel!
  
  func сonfigure(with item: Item?) {
    guard let item = item else { return }
    itemNameLabel.text = item.title
    itemPriceLabel.text = "\(item.currencyCode) \(item.price)"
  }
  
}
