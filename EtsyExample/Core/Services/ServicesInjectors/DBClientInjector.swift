//
//  DBClientInjector.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/7/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import Foundation

struct DBClientInjector {
  
  static var dbClient: DBClient = CoreDataDBClient()
  
}

protocol DBClientInjectable {}

extension DBClientInjectable {
  
  var dbClient: DBClient {
    get {
      return DBClientInjector.dbClient
    }
  }
  
}
