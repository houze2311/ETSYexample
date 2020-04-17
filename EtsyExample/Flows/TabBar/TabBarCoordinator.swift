//
//  TabBarCoordinator.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/3/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import Foundation
import UIKit

class TabBarCoordinator: EventNode, Coordinator {
  
  private weak var root: TabBarController!
  
  func createFlow() -> UIViewController {
    let tabBarController = StoryboardScene.TabBar.tabBarController.instantiate()
    let model = TabBarModel(parent: self)
    tabBarController.model = model
    model.output = tabBarController
    
    root = tabBarController
    
    return tabBarController
  }
  
  func addTabCoordinators(coordinators: [TabBarEmbedCoordinable]) {
    var controllers = [UIViewController]()
    var tabItemMap = [(controller: UIViewController, tabItem: UITabBarItem)]()
    for coordinator in coordinators {
      let controller = coordinator.createFlow()
      
      let tabItem = UITabBarItem(
        title: coordinator.tabItemInfo.title,
        image: coordinator.tabItemInfo.icon,
        selectedImage: coordinator.tabItemInfo.highlightedIcon
      )
      
      tabItemMap.append((controller: controller, tabItem: tabItem))
      controllers.append(controller)
    }
    
    root.configureTabs(with: tabItemMap)
  }
  
}
