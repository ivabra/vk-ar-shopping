//
//  ViewController.swift
//  AR Shopping
//
//  Created by Ivan Brazhnikov on 20.10.2017.
//  Copyright © 2017 Go About. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SceneKit.ModelIO

let CollisionCategoryBottom  = 1 << 0
let CollisionCategoryCube    = 1 << 1

struct ModelSize {
  var width: Float
  var height: Float
  var length: Float
}

extension ARSCNView {
  func setShowFeaturePoints(_ show: Bool) {
    if show {
      debugOptions = SCNDebugOptions(rawValue: debugOptions.rawValue | ARSCNDebugOptions.showFeaturePoints.rawValue)
    } else {
      debugOptions = SCNDebugOptions(rawValue: debugOptions.rawValue ^ ARSCNDebugOptions.showFeaturePoints.rawValue)
    }
  }
}

final class ARViewController: BaseViewController {
  
  
  @IBOutlet private var sceneView: ARSCNView!
  @IBOutlet private var attemptToFindPlaneLabel: UIView!
  @IBOutlet private weak var productTitleLabel: UILabel!
  @IBOutlet private weak var productCategoryLabel: UILabel!
  @IBOutlet private weak var productPriceLabel: UILabel!
  @IBOutlet private weak var productView: UIVisualEffectView!
  @IBOutlet private weak var productImageView: UIImageView!
  
  var product: Product? {
    didSet {
      productView.isHidden = product == nil
      if let product = product {
        productTitleLabel.text = product.title
        productPriceLabel.text = product.price
        productCategoryLabel.text = product.category
        productImageView.sd_setImage(with: product.thumb_photo)
      }
    }
  }
  
  var planes: Set<ARPlaneAnchor> = [] {
    didSet {
      sceneView.setShowFeaturePoints(planes.isEmpty)
      attemptToFindPlaneLabel.isHidden = !planes.isEmpty
    }
  }
  
  
  private var originLoadedModel: SCNNode? {
    didSet {
      reloadTemplateModel()
    }
  }
  
  private var currentFixedModel: SCNNode? {
    didSet {
      if currentFixedModel != nil {
        templateProductNode?.removeFromParentNode()
      } else {
        if let template = templateProductNode {
          sceneView.scene.rootNode.addChildNode(template)
        }
      }
    }
  }
  
  private var templateProductNode: SCNNode? {
    didSet {
      oldValue?.removeFromParentNode()
      if let new = templateProductNode {
        new.opacity = 0.3
        sceneView.scene.rootNode.addChildNode(new)
      }
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
    let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
    pan.maximumNumberOfTouches = 1
    pan.minimumNumberOfTouches = 1
    [tap, pan].forEach(sceneView.addGestureRecognizer(_:))

    sceneView.delegate = self
    sceneView.session.delegate = self
    sceneView.antialiasingMode = .multisampling2X
    sceneView.setShowFeaturePoints(true)
    
    sceneView.scene = SCNScene()
  }

  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    startSession()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    pauseSession()
    super.viewWillDisappear(animated)
  }
   
  
  private func pauseSession() {
    sceneView.session.pause()
  }
  
  private func startSession(reset: Bool = false) {
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = .horizontal
    configuration.isLightEstimationEnabled = true
    if reset {
      planes.removeAll()
      sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    } else {
      sceneView.session.run(configuration)
    }
  }
  
  @objc private func tap(_ gesture: UITapGestureRecognizer) {
    if currentFixedModel == nil {
       placeModel()
    } else {
       unplaceModel()
    } 
  }
  
  private func reloadTemplateModel() {
    templateProductNode = makeModelFromOrigin()
  }
  
  @objc private func pan(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: sceneView)
    gesture.setTranslation(.zero, in: sceneView)
    let angle = translation.x / 100 * .pi
    applyRotationX(angle: Float(angle))
  }

  @IBAction private func back() {
    unloadModel()
    compoundController?.displayShopsUI()
  }
  
  @IBAction private func buy(_ sender: Any) {
    // TODO: buy the product
  }
  
  private func applyRotationX(angle: Float) {
    templateProductNode?.eulerAngles.y += angle
  }
  
  private func applyScaleToTemplateNode(_ scale: Float) {
    guard let node = templateProductNode else {
      return
    }
    var currentScale = node.scale
    currentScale.x += scale
    currentScale.y += scale
    currentScale.z += scale
    node.scale = currentScale
  }
  
  func unplaceModel() {
    if let current = currentFixedModel {
      current.removeFromParentNode()
      currentFixedModel = nil
    }
  }
  private func placeModel() {
    if currentFixedModel != nil {
      return
    }
    guard let view = templateProductNode else {
      return
    }
    
    let clone = view.clone()
    sceneView.scene.rootNode.addChildNode(clone)
    clone.opacity = 1.0
    currentFixedModel = clone
  }
  
  func loadProduct(by url: URL, product: Product? = nil) -> Bool {
    self.product = product
    do {
      let model = try ModelLoader.loadFromZipFile(url)
      model.worldPosition.y -= model.boundingBox.min.y
      self.originLoadedModel = model
      return true
    } catch {
      showErrorAlert(error)
      return false
    }
  }
  
  func unloadModel() {
    product = nil
    originLoadedModel = nil
    unplaceModel()
    if let template = templateProductNode {
      templateProductNode = nil
      template.removeFromParentNode()
    }
  }
  
  
  private func makeModelFromOrigin() -> SCNNode? {
    guard let model = originLoadedModel?.clone() else {
      return nil
    }
    let box = model.boundingBox
    let maxSide = max(box.max.x - box.min.x, box.max.y - box.min.y, box.max.z-box.min.z)
    let scale = ((product?.size ?? 10) / 100) / maxSide
    model.scale = SCNVector3(scale, scale, scale)
    return model
  }
  
  private func moveNodeAtPlane(_ node: SCNNode, to point: CGPoint) -> Bool {
    guard let hit = hitPlane(point) else {
      return false
    }
    moveNodeAtPlane(node, to: hit)
    return true
  }
  
  private func moveNodeAtPlane(_ node: SCNNode, to hitTest: ARHitTestResult) {
    let position = worldPositionFromWorldTransform(hitTest.worldTransform)
    node.position = position
  }
  
  private func hitPlane(_ point: CGPoint) -> ARHitTestResult? {
    return sceneView.hitTest(point, types: .existingPlaneUsingExtent).first
  }
  
  private func hitAnyPlane(_ point: CGPoint) -> ARHitTestResult? {
    return sceneView.hitTest(point, types: [.existingPlaneUsingExtent, .existingPlane]).first
  }

  
  private func invalidatePlaneDetectionView() {
    if let detectionView = templateProductNode {
      if let hit = hitAnyPlane(sceneView.center) {
        moveNodeAtPlane(detectionView, to: hit)
        detectionView.isHidden = false
      } else {
        detectionView.isHidden = true
      }
    }
  }

  
}

extension ARViewController : ARSCNViewDelegate, ARSessionDelegate {
  
  func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
    anchors.flatMap { $0 as? ARPlaneAnchor }.forEach { planes.insert($0) } 
  }
  
  func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
    anchors.flatMap { $0 as? ARPlaneAnchor }.forEach { planes.remove($0) }
  }

  func session(_ session: ARSession, didFailWithError error: Error) {
    print("\(#function) \(error)")
  }
  
  func sessionWasInterrupted(_ session: ARSession) {
    sceneView.setShowFeaturePoints(false)
    print("\(#function)")
  }
  
  func sessionInterruptionEnded(_ session: ARSession) {
    startSession(reset: true)
  }
  
  func session(_ session: ARSession, didUpdate frame: ARFrame) {
    invalidatePlaneDetectionView()
  }
}


func worldPositionFromWorldTransform(_ transform: matrix_float4x4) -> SCNVector3 {
    let c = transform.columns.3
    let worldPosition = SCNVector3Make(c.x, c.y, c.z)
    return worldPosition
}

