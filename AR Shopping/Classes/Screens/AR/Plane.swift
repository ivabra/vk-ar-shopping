//
//  Plane.swift
//  AR Shopping
//
//  Created by Ivan Brazhnikov on 20.10.2017.
//  Copyright © 2017 Go About. All rights reserved.
//

import SceneKit
import ARKit



class Plane: SCNNode {
  
  var planeGeometry: SCNBox!
  var planeNode: SCNNode!
  
  init(anchor: ARPlaneAnchor) {
    let planeGeometry = SCNBox(width: CGFloat(anchor.extent.z), height: 0.01, length: CGFloat(anchor.extent.z), chamferRadius: 0) // SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
    //let material = SCNMaterial()
   // material.diffuse.contents = UIColor.red.withAlphaComponent(0.5)
    //planeGeometry.firstMaterial = material
    let planeNode = SCNNode(geometry: planeGeometry)
    planeNode.simdPosition = simd_float3(anchor.center.x, 0, anchor.center.z)
    self.planeNode = planeNode
    self.planeGeometry = planeGeometry
    super.init()
    isHidden = true
    addChildNode(planeNode)
   // updatePhysic()
  }
  
//  private func updatePhysic() {
//    planeNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: planeGeometry, options: nil))
//  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func update(with anchor: ARPlaneAnchor) {
    self.planeGeometry.width = CGFloat(anchor.extent.x)
    self.planeGeometry.length = CGFloat(anchor.extent.z)
   // updatePhysic()
  }
}

