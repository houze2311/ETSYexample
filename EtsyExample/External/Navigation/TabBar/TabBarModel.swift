//
//  TabBarModel.swift
//  ArchitectureGuideTemplate
//
//  Created by Rumata on 12/9/16.
//

import Foundation
import UIKit

protocol TabBarModelInput {}

protocol TabBarModelOutput: class {}

class TabBarModel: EventNode {
  
  weak var output: TabBarModelOutput!
  
}

extension TabBarModel: TabBarModelInput, TabBarControllerOutput {
  
}
