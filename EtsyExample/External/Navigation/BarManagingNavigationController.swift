//
//  BarManagingNavigationController.swift
//  ArchitectureGuideTemplate
//
//  Created by Yury Grinenko on 01.12.16.
//

import UIKit

/**
 Used to hide navigationBar if number of viewControllers in stack is 1
 */

class BarManagingNavigationController: UINavigationController, UINavigationControllerDelegate {
  
  override func viewDidLoad() {
    delegate = self
    
    super.viewDidLoad()
  }
  
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    setNavigationBarHidden(viewControllers.count == 1, animated: animated)
  }
  
}
