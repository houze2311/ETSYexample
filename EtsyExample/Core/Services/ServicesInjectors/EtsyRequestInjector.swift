//
//  EtsyRequestInjector.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/4/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

struct EtsyRequestInjector: EtsyRequestInjectable {
  static var etsyRequestDecorator = EtsyRequestDecorator()
}

protocol EtsyRequestInjectable {}

extension EtsyRequestInjectable {
  
  var etsyRequestDecorator: EtsyRequestDecorator {
    get {
      return EtsyRequestInjector.etsyRequestDecorator
    }
  }
  
}
