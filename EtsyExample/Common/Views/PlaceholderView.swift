//
//  PlaceholderView.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/13/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import UIKit
import Reusable

final class PlaceholderView: UIView, NibLoadable {
  
  @IBOutlet fileprivate weak var titleLabel: UILabel!
  @IBOutlet fileprivate weak var imageView: UIImageView!
  
  var title: String? {
    didSet {
      if let title = title {
        titleLabel.text = title
      }
    }
  }
  
  var image: UIImage? {
    didSet {
      if let image = image {
        imageView.image = image
      }
    }
  }
  
}
