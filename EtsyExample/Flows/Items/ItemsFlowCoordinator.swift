//
//  ItemsFlowCoordinator.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/3/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import Foundation
import UIKit

class ItemsFlowCoordinator: EventNode, TabBarEmbedCoordinable {
  
  let tabItemInfo = TabBarItemInfo(
    title: L10n.itemsTabbarTitle,
    icon: Asset.TabBar.itemsIcon.image,
    highlightedIcon: nil
  )
  
  fileprivate weak var root: ItemsViewController!
  
  func createFlow() -> UIViewController {
    root = StoryboardScene.Items.itemsViewController.instantiate()
    let model = ItemsModel(parent: self)
    root.model = model
    model.output = root
    
    return UINavigationController(rootViewController: root)
  }
  
  override func handleEvent(_ event: Event) -> Bool {
    if let event = event as? ItemsEvent, case .itemSelected(let item) = event {
      presentDetailedItem(item)
    } else {
      return false
    }
    return true
  }
}

fileprivate extension ItemsFlowCoordinator {
  
  func presentDetailedItem(_ item: Item) {
    let controller = StoryboardScene.Details.detailsViewController.instantiate()
    let model = DetailsModel(parent: self, item: item)
    controller.model = model
    model.output = controller
    root.navigationController!.pushViewController(controller, animated: true)
  }
  
}
