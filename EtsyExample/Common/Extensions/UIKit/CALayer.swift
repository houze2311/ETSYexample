//
//  CALayer.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/4/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import UIKit
import QuartzCore

extension CALayer {
  
  var borderUIColor: UIColor {
    set {
      self.borderColor = newValue.cgColor
    }
    
    get {
      return UIColor(cgColor: self.borderColor!)
    }
  }
  
}
