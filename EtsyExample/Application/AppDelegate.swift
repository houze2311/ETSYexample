//
//  AppDelegate.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/1/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  private var appNavigationCoordinator: AppNavigation!
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    
    appNavigationCoordinator = AppNavigation(window: window!)
    appNavigationCoordinator.startFlow()
    
    AppearanceConfigurator.apply()
    
    return true
  }
  
}
