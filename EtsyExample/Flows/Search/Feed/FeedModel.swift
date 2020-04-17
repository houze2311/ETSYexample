//
//  FeedModel.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/3/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

enum FeedEvent: Event {
  case itemSelected(item: Item)
}

protocol FeedModelInput {
  
  func loadItems(refresh: Bool)
  func categoryName() -> String
  func numberOfItems() -> Int
  func item(at index: Int) -> FeedModel.DisplayableItem?
  func imageURL(at index: Int, completion: @escaping ((_ url: URL?) -> Void))
  func openItemDetails(at index: Int)
  
}

protocol FeedModelOutput: class {
  
  func didStartActivity()
  func didFinishActivity(hasNewData: Bool)
  func didFinishActivity(error: Error)
  func didMissingItems()
  
}

final class FeedModel: EventNode {
  
  enum Activity {
    case reload, loadMore
  }
  
  weak var output: FeedModelOutput!
  
  struct DisplayableItem {
    
    let listingId: Int
    let currencyCode: String
    let price: String
    let title: String
    
  }
  
  fileprivate var category: String!
  fileprivate var keywords: String!
  fileprivate var offset = 0
  fileprivate var items = [Item]()
  fileprivate var isLoadingData = false
  fileprivate var isAvailableData = true
  
  // MARK: - Life cycle
  
  init(parent: EventNode, searchData: DisplayableSearchData) {
    self.category = searchData.category
    self.keywords = searchData.keywords
    super.init(parent: parent)
  }
  
}

extension FeedModel: EtsyRequestInjectable, FeedModelInput, FeedViewControllerOutput {
  
  func categoryName() -> String {
    return category
  }
  
  func loadItems(refresh: Bool) {
    if !isLoadingData && isAvailableData {
      isLoadingData = true
      output.didStartActivity()
      
      let completion: ([Item]?, Int, Error?) -> Void = { [weak self] items, count, error in
        guard let strongSelf = self else { return }
        
        guard let items = items else {
          dump(error)
          strongSelf.output.didFinishActivity(error: error!)
          return
        }
        
        if refresh {
          strongSelf.items.removeAll()
          strongSelf.items = items
        } else {
          strongSelf.items += items
        }

        strongSelf.output.didFinishActivity(hasNewData: true)
        strongSelf.handleOffset(with: count)
        strongSelf.isLoadingData = false
      }
      
      let _ = etsyRequestDecorator.loadItems(
        with: keywords,
        of: category,
        offset: offset,
        completion: completion
      )
    } else {
      output.didFinishActivity(hasNewData: false)
    }
  }
  
  func handleOffset(with count: Int) {
    offset += Constants.UI.paginationLimit
    if offset > count {
      isAvailableData = false
      output.didMissingItems()
    }
  }
  
  func imageURL(at index: Int, completion: @escaping ((_ url: URL?) -> Void)) {
    let listingId = items[index].listingId
    
    let completion: (ImageData?, Error?) -> Void = { imageData, error in
      guard let imageData = imageData, error == nil else { return }
      completion(imageData.standardResolutionUrl)
    }
    
    let _ = etsyRequestDecorator.loadImageData(
      for: listingId,
      completion: completion
    )
  }
  
  func numberOfItems() -> Int {
    return items.count
  }
  
  func item(at index: Int) -> FeedModel.DisplayableItem? {
    return displayableItem(from: items[index])
  }
  
  func openItemDetails(at index: Int) {
    let event = FeedEvent.itemSelected(item: items[index])
    sendUpstream(event: event, from: self)
  }
  
}

fileprivate extension FeedModel {
  
  func displayableItem(from item: Item) -> DisplayableItem {
    return DisplayableItem(
      listingId: item.listingId,
      currencyCode: item.currencyCode,
      price: item.price,
      title: item.title
    )
  }
  
}
