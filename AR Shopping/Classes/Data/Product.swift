//
//  Product.swift
//  AR Shopping
//
//  Created by Ivan Brazhnikov on 20.10.2017.
//  Copyright © 2017 Go About. All rights reserved.
//

import Foundation

struct Product : Codable {
  var id: Int
  var title: String?
  var shop: Int?
  var price: String?
  var category: String?
  var model: URL?
  var thumb_photo: URL?
  var size: Float?
}

struct ProductResponse: Codable {
  var product: Product
}
