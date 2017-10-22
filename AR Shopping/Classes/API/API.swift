//
//  API.swift
//  AR Shopping
//
//  Created by Ivan Brazhnikov on 22.10.2017.
//  Copyright © 2017 Go About. All rights reserved.
//

import Foundation
import Alamofire

final class API {
  
  static let `default` = API()
  
  func shops() throws -> [Shop] {
     return try requestModel(ItemsResponse<Shop>.self, url: Router.shops).items
  }
  
  func products(shopId: Int) throws -> [Product] {
    return try requestModel(ItemsResponse<Product>.self, url: Router.products(shopId: shopId)).items
  }

  func product(id: Int) throws -> Product {
    return try requestModel(ProductResponse.self, url: Router.product(id: id)).product
  }
  
  private func requestModel<T: Decodable, U: URLConvertible>(_ type: T.Type, url: U) throws -> T {
    let data = try Network.default.requestData(url)
    let model = try decoder.decode(type, from: data)
    return model
  }
  
  private init() {}
  private let decoder = JSONDecoder()
  
}
