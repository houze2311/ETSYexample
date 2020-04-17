//
//  Events.swift
//  ArchitectureGuideTemplate
//
//  Created by Rumata on 11/4/16.
//

import Foundation

protocol Event {}

protocol EventDrivenInterface {
  
  func sendDownstream(event: Event)
  func sendUpstream(event: Event, from sender: EventDrivenInterface)
  func handleEvent(_ event: Event) -> Bool
  
}

class EventNode: EventDrivenInterface {
  
  private var parent: EventNode?
  fileprivate lazy var children = NSHashTable<EventNode>.weakObjects()
  fileprivate let identifier = ProcessInfo.processInfo.globallyUniqueString
  
  private init() {}
  
  init(parent: EventNode?) {
    guard let parent = parent else {
      return
    }
    
    parent.addChild(self)
  }
  
  // TODO: Remove debug
  deinit {
    print("Deinit of node: \(self)")
  }
  
  func sendDownstream(event: Event) {
    _ = handleEvent(event)
    children.allObjects.forEach {
      $0.sendDownstream(event: event)
    }
  }
  
  func sendUpstream(event: Event, from sender: EventDrivenInterface) {
    guard let parent = parent else {
      sendDownstream(event: event)
      return
    }
    
    parent.sendUpstream(event: event, from: sender)
  }
  
  func handleEvent(_ event: Event) -> Bool { return false }
  
  func addChild(_ child: EventNode) {
    child.parent = self
    children.add(child)
  }
  
  func removeChild(_ child: EventNode) {
    children.remove(child)
  }
  
}

extension EventNode: Equatable {}

func == (lhs: EventNode, rhs: EventNode) -> Bool {
  return lhs.identifier == rhs.identifier
}
