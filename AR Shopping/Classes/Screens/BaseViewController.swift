//
//  BaseViewController.swift
//  AR Shopping
//
//  Created by Ivan Brazhnikov on 20.10.2017.
//  Copyright © 2017 Go About. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseViewController: UIViewController {
  
  var currentHUD: MBProgressHUD? {
    didSet {
      oldValue?.hide(animated: true)
      currentHUD?.removeFromSuperViewOnHide = true
    }
  }
  
  @discardableResult
  func showHUD() -> MBProgressHUD {
    if let hud = currentHUD {
      return hud
    } else {
      let current = MBProgressHUD.showAdded(to: view, animated: true)
      currentHUD = current
      return current
    }
  }
  
  func showErrorAlert(_ error: Error) {
    let ctr = UIAlertController()
    ctr.title = "Ошибка"
    ctr.message = error.localizedDescription
    ctr.addAction(UIAlertAction.init(title: "ОК", style: .default, handler: nil))
    present(ctr, animated: true, completion: nil)
  }
  
  func hideHUD() {
    currentHUD = nil
  }
}
