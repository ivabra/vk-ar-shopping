//
//  ItemsResponse.swift
//  AR Shopping
//
//  Created by Ivan Brazhnikov on 22.10.2017.
//  Copyright © 2017 Go About. All rights reserved.
//

import Foundation

struct ItemsResponse<T: Codable> : Codable {
  var items: [T]
}
