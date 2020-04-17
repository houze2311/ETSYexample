//
//  TabCoordinator.swift
//  ArchitectureGuideTemplate
//
//  Created by Rumata on 11/18/16.
//

import Foundation
import UIKit

struct TabBarItemInfo {
  
  let title: String?
  let icon: UIImage?
  let highlightedIcon: UIImage?
  
}

protocol TabBarEmbedCoordinable: Coordinator {
  
  var tabItemInfo: TabBarItemInfo { get }
  
}
