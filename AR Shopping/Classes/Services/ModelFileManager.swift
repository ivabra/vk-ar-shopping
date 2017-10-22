//
//  ModelFileManager.swift
//  AR Shopping
//
//  Created by Ivan Brazhnikov on 22.10.2017.
//  Copyright © 2017 Go About. All rights reserved.
//

import Foundation

final class ModelFileManager {
  
  static let `default` = ModelFileManager()
  
  private let modelsRoot: URL
  private init() {
    let fm = FileManager.default
    modelsRoot = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("models")
    if !fm.fileExists(atPath: modelsRoot.path) {
      try? fm.createDirectory(at: modelsRoot, withIntermediateDirectories: true, attributes: nil)
    }
  }
  
  func modelFile(webURL: URL) -> URL {
    return modelsRoot.appendingPathComponent(Int(Date.timeIntervalSinceReferenceDate * 1000).description).appendingPathExtension("zip")
  }
  
}
