//
//  AppNavigationCoordinator.swift
//  ArchitectureGuideTemplate
//
//  Created by Rumata on 11/4/16.
//

import Foundation
import UIKit

final class AppNavigation: RootEventNode {
  
  fileprivate unowned let window: UIWindow
  
  init(window: UIWindow) {
    self.window = window
    
    super.init(parent: nil)
  }
  
  func startFlow() {
    presentMainFlow()
  }
  
  override func handleEvent(_ event: Event) -> Bool {
    if super.handleEvent(event) {
      return true
    }
    return true
  }
  
}

// MARK: Navigation

fileprivate extension AppNavigation {
  
   func presentMainFlow() {
    let coordinator = TabBarCoordinator(parent: self)
    let searchFlow = SearchFlowCoordinator(parent: coordinator)
    let itemsFlow = ItemsFlowCoordinator(parent: coordinator)
    presentCoordinatorFlow(coordinator)
    coordinator.addTabCoordinators(coordinators: [searchFlow, itemsFlow])
  }
  
  private func presentCoordinatorFlow(_ coordinator: Coordinator) {
    let root = coordinator.createFlow()
    window.rootViewController = root
    window.makeKeyAndVisible()
  }
}
