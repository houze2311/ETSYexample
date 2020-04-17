//
//  ItemsResponse.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/3/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import Foundation
import ObjectMapper

struct ItemsResponse {
  var items: [Item]?
  var count: Int?
}

extension ItemsResponse: Mappable {
  
  init?(map: Map) {
    if map.JSON["results"] == nil {
      return nil
    }
  }
  
  mutating func mapping(map: Map) {
    items <- map["results"]
    count <- map["count"]
  }
  
}

struct Item {
  
  var listingId = -1
  var currencyCode = ""
  var itemDescription = ""
  var price = ""
  var title = ""
  /**
   Indicates whether this item stored or public.
   */
  var stored = false
  
}

extension Item: Mappable {
  
  init?(map: Map) {
    if map.JSON["listing_id"] == nil {
      print(map.JSON)
      return nil
    }
  }
  
  mutating func mapping(map: Map) {
    listingId <- map["listing_id"]
    currencyCode <- map["currency_code"]
    itemDescription <- map["description"]
    price <- map["price"]
    title <- map["title"]
  }
  
}
