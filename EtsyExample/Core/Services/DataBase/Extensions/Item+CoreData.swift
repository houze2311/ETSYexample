//
//  Item+CoreData.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/8/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import CoreData

extension Item: CoreDataModelConvertible {
  
  static var entityName: String {
    return "Item"
  }
  
  static var primaryKey: String {
    return "id"
  }
  
  static func managedObjectClass() -> NSManagedObject.Type {
    return ManagedItem.self
  }
  
  static func from(_ managedObject: NSManagedObject) -> Item {
    guard let managedItem = managedObject as? ManagedItem else {
      fatalError("can't create Item object from object \(managedObject)")
    }
    
    var item = Item()
    item.listingId = Int(managedItem.id)
    item.currencyCode = managedItem.currencyCode ?? ""
    item.itemDescription = managedItem.itemDescription ?? ""
    item.price = managedItem.price ?? ""
    item.title = managedItem.title ?? ""
    item.stored = managedItem.stored == false ? true : false
    return item
  }
  
  func toManagedObject(in context: NSManagedObjectContext) -> NSManagedObject {
    let fetchRequest: NSFetchRequest<ManagedItem> = ManagedItem.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id = %@", String(listingId))
    let result = try! context.fetch(fetchRequest)
    let managedItem = result.first ?? ManagedItem(context: context)
    
    managedItem.id = Int64(listingId)
    managedItem.currencyCode = currencyCode
    managedItem.itemDescription = itemDescription
    managedItem.price = price
    managedItem.title = title
    managedItem.stored = stored
    
    return managedItem
  }
  
}
