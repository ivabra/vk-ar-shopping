//
//  Concurrency.swift
//  AR Shopping
//
//  Created by Ivan Brazhnikov on 22.10.2017.
//  Copyright © 2017 Go About. All rights reserved.
//

import Foundation

func UI(_ execute: @escaping () -> Void) {
  DispatchQueue.main.async(execute: execute)
}
