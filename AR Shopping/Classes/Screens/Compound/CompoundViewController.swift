//
//  CompoundViewController.swift
//  AR Shopping
//
//  Created by Ivan Brazhnikov on 22.10.2017.
//  Copyright © 2017 Go About. All rights reserved.
//

import UIKit
import IBSwiftToolKit

class CompoundViewController: BaseViewController {
  
  @IBOutlet weak var blurView: UIView!
  
  private var arViewController: ARViewController!
  private var topViewController: UINavigationController!
  var ntoken: NSObjectProtocol?
  override func viewDidLoad() {
    super.viewDidLoad()
    ntoken = NotificationCenter.default.addObserver(forName: .ApplicationDidReceiveProduct, object: nil, queue: OperationQueue.main) {[weak self] notification in
      if let product = notification.userInfo?["product"] as? Product {
        self?.displayProduct(product)
      }
    }
  }
  
  deinit {
    if let t = ntoken {
      NotificationCenter.default.removeObserver(t)
    }
  }
  
  func displayProduct(_ product: Product) {
    let vc = UIStoryboard(name: "LoadingModelScreen", bundle: .main).instantiateInitialViewController() as! LoadingModelViewController
    vc.product = product
    topViewController?.pushViewController(vc, animated: true)
    displayShopsUI()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ar" {
      arViewController = segue.destination as? ARViewController
    } else if segue.identifier == "ui" {
      topViewController = segue.destination as? UINavigationController
    }
  }
  
  func displayModel(fileURL: URL, product: Product?, popAfterCompletion: Bool = false) {
    UIView.animate(withDuration: 0.5, animations: {
      self.blurView.alpha = 0
    }, completion: { _ in
      self.blurView.isHidden = true
      self.arViewController.loadProduct(by: fileURL, product: product)
      if popAfterCompletion {
        self.topViewController?.popViewController(animated: true)
      }
    })
  }
  
  func displayShopsUI() {
    self.blurView.isHidden = false
    UIView.animate(withDuration: 0.5, animations: {
      self.blurView.alpha = 1
    }, completion: { _ in
      self.arViewController.unloadModel()
    })
  }
  
}

class ClearNavigationController: UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
  }
}

extension UIViewController {
  var compoundController: CompoundViewController? {
    return parentViewControllerWithType(CompoundViewController.self)
  }
}
