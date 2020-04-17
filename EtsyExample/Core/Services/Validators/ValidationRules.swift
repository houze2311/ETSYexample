//
//  ValidationRules.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/4/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import Foundation

protocol ValidationRule {
  
  var errorMessage: String { get }
  func validate(_ value: String) -> Bool
  
}

// MARK: Base Rules

class SuccessRule: ValidationRule {
  
  let errorMessage = ""
  
  func validate(_ value: String) -> Bool {
    return true
  }
  
}

class RequiredRule: ValidationRule {
  
  let errorMessage: String
  
  init(errorMessage: String) {
    self.errorMessage = errorMessage
  }
  
  func validate(_ value: String) -> Bool {
    return !value.isEmpty
  }
  
}

class RegexRule: ValidationRule {
  
  let errorMessage: String
  private let regex: String
  
  init(regex: String, errorMessage: String) {
    self.errorMessage = errorMessage
    self.regex = regex
  }
  
  func validate(_ value: String) -> Bool {
    let predicate = NSPredicate(format: "self matches %@", regex)
    return predicate.evaluate(with: value)
  }
  
}

// MARK: Required Rules

class NameRule: RequiredRule {}
class BioRule: RequiredRule {}
class CompanyRule: SuccessRule {}
class LocationRule: SuccessRule {}

class BlogURLRule: RegexRule {
  
  private static let blogURLRegex = "http?://([-\\w\\.]+)+(:\\d+)?(/([\\w/_\\.]*(\\?\\S+)?)?)?"
  
  convenience init(errorMessage: String) {
    self.init(regex: BlogURLRule.blogURLRegex, errorMessage: errorMessage)
  }
  
}
