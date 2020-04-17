//
//  DetailsModel.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/3/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

enum DetailsEvent: Event {
  case storedItemsUpdated
}

protocol DetailsModelInput {

  func isStoredItem() -> Bool
  func getItemDetails()
  func getItemImageUrl()
  func addItemInDataBase()
  func removeItemFromDataBase()
  
}

protocol DetailsModelOutput: class {
 
  func didPrepareDisplayableItem(_ item: DetailsModel.DisplayableItem)
  func didPrepareItemImageUrl(_ url: URL?)
  
  func didStartActivity()
  func didFinishActivity(hasNewData: Bool)
  func didFinishActivity(error: Error)
  
  func didSaveItem()
  func didRemoveItem()
  func didFailItemAction(error: Error)

}

final class DetailsModel: EventNode {
  
  weak var output: DetailsModelOutput!
  
  fileprivate var item: Item!
  fileprivate var isLoadingData = false
  
  init(parent: EventNode, item: Item) {
    self.item = item
    super.init(parent: parent)
  }
  
}

extension DetailsModel: EtsyRequestInjectable, DBClientInjectable, DetailsModelInput, DetailsViewControllerOutput {
  
  struct DisplayableItem {
    
    var title = ""
    var itemDescription = ""
    var currencyCode = ""
    var price = ""
    
  }
  
  func isStoredItem() -> Bool {
    return item.stored
  }
  
  func getItemDetails() {
    let preparedItem = displayableItem(from: item)
    output.didPrepareDisplayableItem(preparedItem)
  }
  
  func getItemImageUrl() {
    if !isLoadingData {
      isLoadingData = true
      output.didStartActivity()
      
      let completion: (ImageData?, Error?) -> Void = { [weak self] imageData, error in
        guard let strongSelf = self else { return }
        
        guard let imageData = imageData else {
          dump(error)
          strongSelf.output.didFinishActivity(error: error!)
          return
        }
        
        strongSelf.output.didFinishActivity(hasNewData: true)
        strongSelf.output.didPrepareItemImageUrl(imageData.fullResolutionUrl)
        
        strongSelf.isLoadingData = false
      }
      
      let _ = etsyRequestDecorator.loadImageData(
        for: item.listingId,
        completion: completion
      )
    } else {
      output.didFinishActivity(hasNewData: false)
    }
  }
  
  func addItemInDataBase() {
    dbClient.save([item]).continueWith { [weak self] task in
      guard let strongSelf = self else { return }
      
      if let error = task.error {
        strongSelf.output.didFailItemAction(error: error)
      } else {
        strongSelf.output.didSaveItem()
        let event = DetailsEvent.storedItemsUpdated
        strongSelf.sendUpstream(event: event, from: strongSelf)
      }
    }
  }
  
  func removeItemFromDataBase() {
    dbClient.delete([item]).continueWith { [weak self] task in
      guard let strongSelf = self else { return }
      
      if let error = task.error {
        strongSelf.output.didFailItemAction(error: error)
      } else {
        strongSelf.output.didRemoveItem()
        let event = DetailsEvent.storedItemsUpdated
        strongSelf.sendUpstream(event: event, from: strongSelf)
      }
    }
  }
  
}

fileprivate extension DetailsModel {
  
  func displayableItem(from item: Item) -> DisplayableItem {
    return DisplayableItem(
      title: item.title,
      itemDescription: item.itemDescription,
      currencyCode: item.currencyCode,
      price: item.price
    )
  }
  
}
