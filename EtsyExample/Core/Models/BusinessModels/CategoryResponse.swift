//
//  CategoriesResponse.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/4/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import Foundation
import ObjectMapper

struct CategoriesResponse {
  var categories: [Category]?
}

extension CategoriesResponse: Mappable {
  
  init?(map: Map) {
    if map.JSON["results"] == nil {
      return nil
    }
  }
  
  mutating func mapping(map: Map) {
    categories <- map["results"]
  }
  
}

struct Category {
  var categoryId = -1
  var shortName = ""
  var longName = ""
}

extension Category: Mappable {
  
  init?(map: Map) {
    if map.JSON["category_id"] == nil {
      return nil
    }
  }
  
  mutating func mapping(map: Map) {
    categoryId <- map["category_id"]
    shortName <- map["short_name"]
    longName <- map["long_name"]
  }
}
