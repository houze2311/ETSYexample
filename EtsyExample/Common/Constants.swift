//
//  Constants.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/5/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import Foundation

enum Constants {
  
  enum API {
    
    static let baseURL = URL(string: "https://openapi.etsy.com/v2/")!
  }
  
  enum Etsy {
    
    static let apiKey = "btlcoly8wtgseiid2xuw4izt"
    
  }
  
  enum Path {
    
    static let categories = "taxonomy/categories"
    static let listings = "listings/active"
    
  }
  
  enum UI {
    
    static let paginationLimit = 20
    
  }
  
}
