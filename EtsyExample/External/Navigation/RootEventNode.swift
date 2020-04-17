//
//  RootCoordinator.swift
//  ArchitectureGuideTemplate
//
//  Created by Rumata on 12/6/16.
//

import Foundation
import UIKit

enum RegistryEvent {
  case addEventHandler(handler: EventNode)
  case removeEventHandler(handler: EventNode)
}

class RootEventNode: EventNode {
  
  private lazy var dispatchRegistry = [EventNode]()
  
  override func handleEvent(_ event: Event) -> Bool {
    if let event = event as? RegistryEvent {
      switch event {
      case .addEventHandler(let handler):
        dispatchRegistry.append(handler)
        
      case .removeEventHandler(let handler):
        dispatchRegistry.remove(object: handler)
        
      }
    } else {
      return false
    }
    
    return true
  }
  
  override func sendDownstream(event: Event) {
    if !dispatchRegistry.isEmpty {
      dispatchRegistry.reversed().forEach { handler in
        if handler.handleEvent(event) {
          return
        }
      }
    }
    super.sendDownstream(event: event)
  }
  
}
