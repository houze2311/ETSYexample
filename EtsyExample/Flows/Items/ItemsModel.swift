//
//  ItemsModel.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/3/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import BoltsSwift

enum ItemsEvent: Event {
  case itemSelected(item: Item)
}

protocol ItemsModelInput {

  func reloadItems(update: Bool)
  func numberOfItems() -> Int
  func item(at index: Int) -> Item?
  func openItemDetails(at index: Int)
  
}

protocol ItemsModelOutput: class/*, ModelOutput*/ {

  func didUpdateStorage()

}

final class ItemsModel: EventNode {
  
  weak var output: ItemsModelOutput!
  fileprivate var items = [Item]()
  
  override func handleEvent(_ event: Event) -> Bool {
    if let event = event as? DetailsEvent, case .storedItemsUpdated = event {
      reloadItems(update: true)
    } else {
      return false
    }
    return true
  }
  
}

extension ItemsModel: DBClientInjectable, ItemsModelInput, ItemsViewControllerOutput {
  
  func reloadItems(update: Bool) {
    loadItemsFromDatabase().continueWith { [weak self] task in
      guard let strongSelf = self else { return }
      if let items = task.result {
        strongSelf.items = items
        if update {
          strongSelf.output.didUpdateStorage()
        }
      } else if let error = task.error {
        // There is no need to show error to user because we have network request to resque
        dump(error)
      }
    }
  }
  
  func numberOfItems() -> Int {
    return items.count
  }
  
  func item(at index: Int) -> Item? {
    return items[index]
  }
  
  func openItemDetails(at index: Int) {
    let event = ItemsEvent.itemSelected(item: items[index])
    sendUpstream(event: event, from: self)
  }
  
}

fileprivate extension ItemsModel {
  
  func loadItemsFromDatabase() -> Task<[Item]> {
    return dbClient.fetch(with: nil)
  }
  
}
