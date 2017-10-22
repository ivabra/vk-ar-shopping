//
//  ModelWrapperNode.swift
//  AR Shopping
//
//  Created by Ivan Brazhnikov on 21.10.2017.
//  Copyright © 2017 Go About. All rights reserved.
//

import SceneKit

class ModelWrapperNode: SCNNode {
  
  var wrapped: SCNNode? {
    return childNode(withName: "wrapped", recursively: true)
  }
  
  override init() {
    super.init()
  }
  
  init(wrapping: SCNNode?) {
    super.init()
    if let wrapping = wrapping {
      wrapping.name = "wrapped"
      addChildNode(wrapping)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
