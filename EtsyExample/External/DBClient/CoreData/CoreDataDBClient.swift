//
//  CoreDataDBClient.swift
//  ArchitectureGuideTemplate
//
//  Created by Yury Grinenko on 03.11.16.
//

import CoreData
import BoltsSwift

/**
  Describes type of model for CoreData database client.
  Model should conform to CoreDataModelConvertible protocol
  for ability to be fetched/saved/updated/deleted in CoreData
*/
public protocol CoreDataModelConvertible: Stored {

  /**
    Returns type of object for model.
  */
  static func managedObjectClass() -> NSManagedObject.Type

  /**
    Executes mapping from `NSManagedObject` instance.
    
    - Parameter managedObject: Object to be mapped from
     
    - Returns: Mapped object.
  */
  static func from(_ managedObject: NSManagedObject) -> Self

  /**
    Executes backward mapping to `NSManagedObject` from given context
     
    - Parameter context: Context, where object should be created.
     
    - Returns: Created instance
  */
  func toManagedObject(in context: NSManagedObjectContext) -> NSManagedObject

  static var entityName: String { get }
  
}

extension NSManagedObject: Stored {}

// TODO: If it is possible, need some way to avoid calling DBClient functions with objects
// which don't conform to CoreDataModelConvertible protocol - generate compile time error

/** 
  Implementation of database client for CoreData storage type.
*/
public class CoreDataDBClient {
  
  public init() {
    initializeCoreDataStack()
  }
  
  fileprivate var container: NSPersistentContainer!
  
  private func initializeCoreDataStack() {
    container = NSPersistentContainer(name: "CoreData")
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error {
        fatalError("Unresolved error \(error), \(error.localizedDescription)")
      }
    }
  }
  
}

extension CoreDataDBClient: DBClient {
  
  public func execute<T: Stored>(_ request: FetchRequest<T>) -> Task<[T]> {
    guard let coreDataModelType = T.self as? CoreDataModelConvertible.Type else {
      fatalError("CoreDataDBClient can manage only types which conform to CoreDataModelConvertible")
    }
    
    let taskCompletionSource = TaskCompletionSource<[T]>()
    
    container.performBackgroundTask { context in
      let fetchRequest = coreDataModelType.managedObjectClass().fetchRequest()
      fetchRequest.predicate = request.predicate
      fetchRequest.sortDescriptors = [request.sortDescriptor].compactMap { $0 }
      fetchRequest.fetchLimit = request.fetchLimit
      fetchRequest.fetchOffset = request.fetchOffset
      do {
        let result = try context.fetch(fetchRequest) as! [NSManagedObject]
        let resultModels = result.map { coreDataModelType.from($0) as! T }
        taskCompletionSource.set(result: resultModels)
      } catch {
        // TODO - generate proper error
        let error = NSError()
        taskCompletionSource.set(error: error)
      }
    }
    
    return taskCompletionSource.task
  }

  public func observable<T: Stored>(for request: FetchRequest<T>) -> RequestObservable<T> {
    return CoreDataObservable(request: request, context: container.newBackgroundContext())
  }
  
  public func fetch<T: Stored>(id: String) -> Task<[T]> {
    let predicate = NSPredicate(format: "id = %@", id)
    return fetch(with: predicate)
  }
  
  public func save<T: Stored>(_ objects: [T]) -> Task<[T]> {
    // For each element in collection:
    // 1. Cast T object to CoreDataModelConvertible if it is possible
    // 2. Convert CoreDataModelConvertible object to CoreData object in given context
    // After all inserts/updates try to save context
    
    let taskCompletionSource = TaskCompletionSource<[T]>()
    container.performBackgroundTask { context in
      for object in objects {
        if let coreDataConvertibleObject = object as? CoreDataModelConvertible {
          let _ = coreDataConvertibleObject.toManagedObject(in: context)
        }
      }
      do {
        try context.save()
        taskCompletionSource.set(result: objects)
      } catch {
        // TODO - generate proper error
        let error = NSError()
        taskCompletionSource.set(error: error)
      }
    }
    return taskCompletionSource.task
  }
  
  public func update<T: Stored>(_ objects: [T]) -> Task<[T]> {
    // For each element in collection:
    // 1. Cast T object to CoreDataModelConvertible if it is possible
    // 2. Convert CoreDataModelConvertible object to CoreData object in given context
    // After all inserts/updates try to save context

    // The same logic as for Save actions
    return save(objects)
  }

  public func delete<T: Stored>(_ objects: [T]) -> Task<[T]> {
    // For each element in collection:
    // 1. Cast T object to CoreDataModelConvertible if it is possible
    // 2. Convert CoreDataModelConvertible object to CoreData object in given context
    // 3. Delete CoreData object from context
    // After all deletes try to save context

    let taskCompletionSource = TaskCompletionSource<[T]>()
    container.performBackgroundTask { context in
      for object in objects {
        if let coreDataConvertibleObject = object as? CoreDataModelConvertible {
          let managedObject = coreDataConvertibleObject.toManagedObject(in: context)
          context.delete(managedObject)
        }
      }
      do {
        try context.save()
        taskCompletionSource.set(result: objects)
      } catch {
        // TODO - generate proper error
        let error = NSError()
        taskCompletionSource.set(error: error)
      }
    }
    return taskCompletionSource.task
  }
  
  public func fetch<T: Stored>(with predicate: NSPredicate? = nil) -> Task<[T]> {
    // 1. Make sure passed T type conforms to CoreDataModelConvertible protocol to fetch from CoreData DB
    // 2. Convert type to CoreDataModelConvertible type
    // 3. Create required NSFetchRequest with passed predicate
    // 4. Fetch items of CoreDataModelConvertible type
    // 5. Convert fetched items back to T type
    
    // warning: Use preconditions
    
    guard let coreDataModelType = T.self as? CoreDataModelConvertible.Type else {
      fatalError("CoreDataDBClient can manage only types which conform to CoreDataModelConvertible")
    }
    
    let taskCompletionSource = TaskCompletionSource<[T]>()
    
    container.performBackgroundTask { context in
      let fetchRequest = coreDataModelType.managedObjectClass().fetchRequest()
      fetchRequest.predicate = predicate
      do {
        let result = try context.fetch(fetchRequest) as! [NSManagedObject]
        let resultModels = result.map { coreDataModelType.from($0) as! T }
        taskCompletionSource.set(result: resultModels)
      } catch {
        // TODO - generate proper error
        let error = NSError()
        taskCompletionSource.set(error: error)
      }
    }
    return taskCompletionSource.task
  }

}
