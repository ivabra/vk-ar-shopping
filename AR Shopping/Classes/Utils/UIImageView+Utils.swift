//
//  UIImageView+Utils.swift
//  AR Shopping
//
//  Created by Ivan Brazhnikov on 22.10.2017.
//  Copyright © 2017 Go About. All rights reserved.
//

import Foundation
import class UIKit.UIImage

extension UIImage {
  static func random() -> UIImage? {
    let index = arc4random_uniform(4)
    let name = "rand-image-\(index)"
    return UIImage(named: name)
  }
}
