//
//  BaseComountChildViewController.swift
//  AR Shopping
//
//  Created by Ivan Brazhnikov on 22.10.2017.
//  Copyright © 2017 Go About. All rights reserved.
//

import UIKit

class BaseCompoundChildViewController: BaseViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UIView.animate(withDuration: 0.33) {
      self.view.backgroundColor = .clear
    }
  }
}
