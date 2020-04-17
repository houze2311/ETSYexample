//
//  Array.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/3/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
  
  // Remove first collection element that is equal to the given `object`:
  mutating func remove(object: Element) {
    if let index = index(of: object) {
      remove(at: index)
    }
  }
}
