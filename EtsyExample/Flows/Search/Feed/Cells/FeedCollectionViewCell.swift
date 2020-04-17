//
//  FeedCollectionViewCell.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/5/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import UIKit
import Reusable
import SDWebImage

final class FeedCollectionViewCell: UICollectionViewCell, NibReusable {
  
  @IBOutlet fileprivate weak var itemImageView: UIImageView!
  @IBOutlet fileprivate weak var itemNameLabel: UILabel!
  @IBOutlet fileprivate weak var itemPriceLabel: UILabel!
  
  func сonfigure(with item: FeedModel.DisplayableItem?) {
    guard let item = item else { return }
    itemImageView.image = nil
    itemNameLabel.text = item.title.capitalized
    itemPriceLabel.text = "\(item.currencyCode) \(item.price)"
  }
  
  func setImage(with url: URL?) {
    itemImageView.sd_setImage(
      with: url,
      placeholderImage: Asset.SearchFlow.placeholder.image
    )
  }
  
}
