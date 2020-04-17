//
//  Validator.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/4/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

final class Validator {
  
  var errorMessage: String?
  
  private let rules: [ValidationRule]
  
  init(rules: [ValidationRule]) {
    self.rules = rules
  }
  
  func validate(_ value: String) -> Bool {
    for rule in rules {
      if !rule.validate(value) {
        errorMessage = rule.errorMessage
        return false
      }
    }
    errorMessage = nil
    return true
  }
  
}
