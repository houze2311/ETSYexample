//
//  StatusPresenting.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/3/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

protocol StatusPresenting {

  func presentError(message: String)
  func presentSuccess(message: String)
  func presentStatus(message: String)
  
}
