//
//  AppDelegate.swift
//  AR Shopping
//
//  Created by Ivan Brazhnikov on 20.10.2017.
//  Copyright © 2017 Go About. All rights reserved.
//

import UIKit

extension Notification.Name {
  static let ApplicationDidReceiveProduct = Notification.Name("ApplicationDidReceiveProduct")
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    application.statusBarStyle = .lightContent
    return true
  }

  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    guard url.scheme == "rubervk" else {
      return false
    }
    if let productId = Int(url.lastPathComponent) {
      Network.dispatch {
        do {
          let product = try API.default.product(id: productId)
          NotificationCenter.default.post(Notification(name: .ApplicationDidReceiveProduct, object: nil, userInfo: ["product" : product]))
        } catch {
          print(error)
        }
      }
    }
    
    return true
  }
}

