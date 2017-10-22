//
//  LoadingModelViewController.swift
//  AR Shopping
//
//  Created by Ivan Brazhnikov on 22.10.2017.
//  Copyright © 2017 Go About. All rights reserved.
//

import UIKit
import Alamofire

final class LoadingModelViewController: BaseCompoundChildViewController {
  
  var product: Product!
  weak var currentRequest: DownloadRequest?

  @IBOutlet weak var progressView: UIProgressView!
  
  
  @IBOutlet weak var modelImageView: UIImageView!
  @IBOutlet weak var productNameLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadModel()
  }
  
  deinit {
     currentRequest?.cancel()
  }
  
  @IBAction func cancel(_ sender: Any) {
    currentRequest?.cancel()
    navigationController?.popViewController(animated: true)
  }
  
  func loadModel() {
    guard let product = product else { return }
    
    modelImageView.sd_setImage(with: product.thumb_photo)
    productNameLabel.text = product.title
    
    guard let modelURL = product.model else { return }
    
    let modelFileURL = ModelFileManager.default.modelFile(webURL: modelURL)
    
    if FileManager.default.fileExists(atPath: modelFileURL.path) {
      displayModel(modelFileURL)
      return
    }
    
    let dest: DownloadRequest.DownloadFileDestination = { _, _ in
      (modelFileURL, DownloadRequest.DownloadOptions.createIntermediateDirectories)
    }
    currentRequest = download(modelURL, to: dest).downloadProgress { progress in
      UI { [weak self] in
        self?.displayProgress(progress)
      }
    }.response { (response) in
        print(response)
        UI { [weak self] in
          self?.handleResponse(response)
        }
    }
  }
  
  func displayProgress(_ progress: Progress) {
    progressView.progress = Float(progress.fractionCompleted)
  }
  
  func handleResponse(_ response: DefaultDownloadResponse) {
    guard let fileURL = response.destinationURL else {
      navigationController?.popViewController(animated: true)
      return
    }
    displayModel(fileURL)
  }
  
  func displayModel(_ url: URL) {
    compoundController?.displayModel(fileURL: url, product: product, popAfterCompletion: true)
  }
}
