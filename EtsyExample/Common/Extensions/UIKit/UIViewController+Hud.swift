//
//  UIViewController+Hud.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/4/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import UIKit
import KVNProgress

typealias HudCompletion = (() -> Void)

fileprivate let progressHudFontSize: CGFloat = 15
fileprivate let minimumSuccessDisplayTime = 2.0
fileprivate let minimumErrorDisplayTime = 2.5

extension UIViewController {
  
  func showErrorHud(with errorStatus: String, completion: HudCompletion? = nil) {
    KVNProgress.setConfiguration(self.hudConfiguration())
    KVNProgress.showError(withStatus: errorStatus)
    dismiss(completion: completion)
  }
  
  func showSuccessHud(with successStatus: String, completion: HudCompletion? = nil) {
    KVNProgress.setConfiguration(self.hudConfiguration())
    KVNProgress.showSuccess(withStatus: successStatus)
    dismiss(completion: completion)
  }
  
  func showHud(with statusMessage: String) {
    KVNProgress.setConfiguration(self.hudConfiguration())
    KVNProgress.show(withStatus: statusMessage)
  }
  
  func hideHud(_ completion: HudCompletion? = nil) {
    if let completion = completion {
      KVNProgress.dismiss {
        completion()
      }
    }
    
    if KVNProgress.isVisible() {
      KVNProgress.dismiss()
    }
  }
  
  func updateStatus(newStatusMessage: String) {
    KVNProgress.updateStatus(newStatusMessage)
  }
  
  func hideHud(successStatus: String, completion: HudCompletion? = nil) {
    KVNProgress.setConfiguration(self.hudConfiguration())
    KVNProgress.showSuccess(withStatus: successStatus)
    dismiss(completion: completion)
  }
  
  func hideHud(errorStatus: String, completion: HudCompletion? = nil) {
    KVNProgress.setConfiguration(self.hudConfiguration())
    KVNProgress.showError(withStatus: errorStatus)
    dismiss(completion: completion)
  }
  
}

fileprivate extension UIViewController {
  
  func hudConfiguration() -> KVNProgressConfiguration {
    let hudConfiguration = KVNProgressConfiguration()
    hudConfiguration.statusColor = UIColor.white
    hudConfiguration.backgroundFillColor = UIColor.black.withAlphaComponent(0.8)
    hudConfiguration.statusFont = UIFont.systemFont(ofSize: progressHudFontSize)
    hudConfiguration.circleStrokeForegroundColor = UIColor.white
    hudConfiguration.successColor = UIColor.white
    hudConfiguration.errorColor = UIColor.white
    hudConfiguration.isFullScreen = true
    hudConfiguration.backgroundType = .solid
    hudConfiguration.minimumSuccessDisplayTime = minimumSuccessDisplayTime
    hudConfiguration.minimumErrorDisplayTime = minimumErrorDisplayTime
    return hudConfiguration
  }
  
  func dismiss(completion: HudCompletion?) {
    DispatchQueue.main.asyncAfter(deadline: .now() + minimumSuccessDisplayTime) {
      KVNProgress.dismiss()
      completion?()
    }
  }
  
}
