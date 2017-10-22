//
//  Router.swift
//  AR Shopping
//
//  Created by Ivan Brazhnikov on 22.10.2017.
//  Copyright © 2017 Go About. All rights reserved.
//

import Foundation
import Alamofire

private let root = URL(string: "https://stutab.ru/api")!

enum Router {
  case shops
  case shop(id: Int)
  case products(shopId: Int)
  case product(id: Int)
}

extension Router : URLConvertible {
  func asURL() throws -> URL {
    switch self {
    case .shops: return root.appendingPathComponent("shops")
    case .shop(let id): return root.appendingPathComponent("shop").appendingPathComponent("\(-id)")
    case .products(let shopId): return try Router.shop(id: shopId).asURL().appendingPathComponent("products")
    case .product(let id): return root.appendingPathComponent("product").appendingPathComponent("\(id)")
    }
  }
}
