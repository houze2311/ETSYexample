//
//  DatabaseError.swift
//  ArchitectureGuideTemplate
//
//  Created by Serhii Butenko on 19/12/16.
//

import Foundation

/// Transaction error type.
///
/// - write: For write transactions.
/// - read: For read transactions.
public enum DatabaseError: Error {
  
  case write, read
}
