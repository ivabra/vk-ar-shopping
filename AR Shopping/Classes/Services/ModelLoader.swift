//
//  ModelLoader.swift
//  AR Shopping
//
//  Created by Ivan Brazhnikov on 21.10.2017.
//  Copyright © 2017 Go About. All rights reserved.
//

import Foundation
import Zip
import SceneKit

enum ModelLoader {

  private static let supportedFormats = Set(["obj", "stl"])
  
  enum Errors: Error {
    case NoModelFile
    case CouldNotLoadScene
  }
  
  static func loadFromZipFile(_ zipFileURL: URL) throws -> SCNNode  {
    
    let unzippedURL = try Zip.quickUnzipFile(zipFileURL)
    let fm = FileManager.default
    let modelFiles = try fm.contentsOfDirectory(at: unzippedURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
    let sceneFile: URL
    
    if let objFile = modelFiles.first (where: {  supportedFormats.contains($0.pathExtension) }) {
      sceneFile = objFile
    } else {
      throw Errors.NoModelFile
    }

    return try SCNScene(url: sceneFile, options: nil).rootNode.clone()
//
//    let stageAsset = MDLAsset(url: sceneFile)
//    stageAsset.loadTextures()
//
//    guard stageAsset.count > 0 else {
//      throw Errors.CouldNotLoadScene
//    }
//   let stageObject = stageAsset.object(at: 0)
//   return SCNNode(mdlObject: stageObject)
  }
  
}

extension MDLMesh {
  func applyMaterialToSubmeshs(_ material: MDLMaterial) {
    self.submeshes?.forEach { mesh in
      (mesh as? MDLSubmesh)?.material = material
    }
  }
}
