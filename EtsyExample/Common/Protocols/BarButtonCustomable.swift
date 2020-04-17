//
//  BarButtonCustomable.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/5/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import UIKit

protocol BarButtonCustomable {}

extension BarButtonCustomable {
  var buttonWithoutTitle: UIBarButtonItem {
    return UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
}
