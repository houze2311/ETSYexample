//
//  SpinnerPresenting.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/3/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

protocol SpinnerPresenting {
  
  func showSpinner(message: String?, blockUI: Bool)
  func hideSpinner()
  
}
