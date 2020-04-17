//
//  TabBarController.swift
//  ArchitectureGuideTemplate
//
//  Created by Rumata on 12/9/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import UIKit

protocol TabBarControllerOutput: TabBarModelInput {}
protocol TabBarControllerInput: TabBarModelOutput {}

class TabBarController: UITabBarController {
  
  var model: TabBarControllerOutput!
  
  func configureTabs(with configuration: [(controller: UIViewController, tabItem: UITabBarItem)]) {
    let controllers = configuration.map { $0.controller }
    setViewControllers(controllers, animated: false)
    // We should set tabbarItems after setting controllers to allow changes to apply
    configuration.forEach { $0.controller.tabBarItem = $0.tabItem }
  }
  
}

extension TabBarController: TabBarControllerInput {}
