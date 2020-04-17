//
//  ManagedItem+CoreDataProperties.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/8/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import Foundation
import CoreData

extension ManagedItem {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedItem> {
    return NSFetchRequest<ManagedItem>(entityName: Item.entityName);
  }
  
  @NSManaged public var currencyCode: String?
  @NSManaged public var id: Int64
  @NSManaged public var itemDescription: String?
  @NSManaged public var price: String?
  @NSManaged public var stored: Bool
  @NSManaged public var title: String?
  
}
