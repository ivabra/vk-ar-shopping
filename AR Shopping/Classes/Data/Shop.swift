//
//  Shop.swift
//  AR Shopping
//
//  Created by Ivan Brazhnikov on 20.10.2017.
//  Copyright © 2017 Go About. All rights reserved.
//

import Foundation

struct Shop: Codable {
  
  var id: Int
  var title: String?
  var categories: Categories?
  var productsCount: Int?
  
  struct Categories: Codable {
    var count: Int
    var items: [ProductCategory]
  }
}

