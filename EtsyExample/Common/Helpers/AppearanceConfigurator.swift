//
//  AppearanceConfigurator.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/4/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import UIKit

struct AppearanceConfigurator {
  
  static func apply() {
    configureNavigationBar()
    configureTextField()
    configureTextView()
    configureTabBar()
  }
  
}

fileprivate extension AppearanceConfigurator {
  
  static func configureNavigationBar() {
    UIApplication.shared.statusBarStyle = .lightContent
    
    UINavigationBar.appearance().barTintColor = UIColor(named: .defaultOrangeColor)
    UINavigationBar.appearance().isTranslucent = false
    UINavigationBar.appearance().tintColor = UIColor.white
    let attributes = [
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium),
        NSAttributedString.Key.foregroundColor : UIColor.white
    ]
    UINavigationBar.appearance().titleTextAttributes = attributes
    
    let backButton = Asset.NavigationBar.backBarButton.image
    UINavigationBar.appearance().backIndicatorImage = backButton
    UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButton
  }
  
  static func configureTextField() {
    UITextField.appearance().tintColor = UIColor(named: .defaultOrangeColor)
  }
  
  static func configureTextView() {
    UITextView.appearance().tintColor = UIColor(named: .defaultOrangeColor)
  }
  
  static func configureTabBar() {
    UITabBar.appearance().backgroundColor = UIColor(named: .tabBarBackgroundColor)
    UITabBar.appearance().tintColor = UIColor(named: .defaultOrangeColor)
  }
  
}
