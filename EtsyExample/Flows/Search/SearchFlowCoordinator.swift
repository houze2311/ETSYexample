//
//  SearchFlowCoordinator.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/3/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import Foundation
import UIKit

class SearchFlowCoordinator: EventNode, TabBarEmbedCoordinable {
  
  let tabItemInfo = TabBarItemInfo(
    title: L10n.searchTabbarTitle,
    icon: Asset.TabBar.searchIcon.image,
    highlightedIcon: nil
  )
  
  fileprivate weak var root: SearchViewController!
  
  func createFlow() -> UIViewController {
    root = StoryboardScene.Search.searchViewController.instantiate()
    let model = SearchModel(parent: self)
    root.model = model
    model.output = root
    
    return UINavigationController(rootViewController: root)
  }
  
  override func handleEvent(_ event: Event) -> Bool {
    if let event = event as? SearchEvent, case .searchDataPrepared(let searchData) = event {
      presentFeed(with: searchData)
    } else if let event = event as? FeedEvent, case .itemSelected(let item) = event {
      presentDetailedItem(item)
    } else {
      return false
    }
    return true
  }
  
}

fileprivate extension SearchFlowCoordinator {
  
  func presentFeed(with searchData: DisplayableSearchData) {
    let controller = StoryboardScene.Search.feedViewController.instantiate()
    let model = FeedModel(parent: self, searchData: searchData)
    controller.model = model
    model.output = controller
    root.navigationController?.pushViewController(controller, animated: true)
  }
  
  func presentDetailedItem(_ item: Item) {
    let controller = StoryboardScene.Details.detailsViewController.instantiate()
    let model = DetailsModel(parent: self, item: item)
    controller.model = model
    model.output = controller
    root.navigationController!.pushViewController(controller, animated: true)
  }
  
}
