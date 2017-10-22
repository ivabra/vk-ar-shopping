//
//  API.swift
//  AR Shopping
//
//  Created by Ivan Brazhnikov on 22.10.2017.
//  Copyright © 2017 Go About. All rights reserved.
//

import Foundation
import Alamofire

final class Network {
  
  static let `default` = Network()
  
  enum Errors: Error {
    case noResponse
  }
  
  func requestData<T: URLConvertible>(_ url: T) throws -> Data {
    let sem = DispatchSemaphore(value: 0)
    var dataResponse: DataResponse<Data>?
    var async = true
    request(url).responseData { _dataResponse -> Void in
      async = false
      dataResponse = _dataResponse
      sem.signal()
    }
    if async {
      sem.wait()
    }
    guard let response = dataResponse else {
      throw Errors.noResponse
    }
    switch response.result {
    case .success(let data):
      return data
    case .failure(let error):
      throw error
    }
  }
  
}

extension Network {
  
  static private let queue = DispatchQueue(label: "ruber.network", qos: .utility, attributes: .concurrent)
  
  static func dispatch(_ execute: @escaping () -> Void) {
    queue.async(execute: execute)
  }
}


