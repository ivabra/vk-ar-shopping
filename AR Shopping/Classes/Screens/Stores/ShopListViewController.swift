//
//  ShopListViewController.swift
//  AR Shopping
//
//  Created by Ivan Brazhnikov on 20.10.2017.
//  Copyright © 2017 Go About. All rights reserved.
//

import UIKit

final class ShopListViewController: BaseCompoundChildViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var shops: [Shop] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadProducts()
  }
  
  
  func loadProducts() {
    showHUD()
    Network.dispatch {
      defer {
        UI { [weak self] in
          self?.hideHUD()
        }
      }
      do {
        let shops = try API.default.shops()
        UI { [weak self] in
          self?.shops = shops
        }
      } catch {
        print(error)
      }
    }
  }
  
}

extension ShopListViewController : UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return shops.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let shop = shops[indexPath.item]
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = shop.title
    cell.detailTextLabel?.text = "\(shop.categories?.count ?? 0)" + " категорий"
    cell.imageView?.image = .random()
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    (segue.destination as? ProductListViewController)?.shop = sender as? Shop
  }
}

extension ShopListViewController : UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let shop = shops[indexPath.item]
    performSegue(withIdentifier: "products", sender: shop)
  }
}

class ShopListCell: UITableViewCell {
  @IBOutlet private weak var _imageView: UIImageView?
  @IBOutlet private weak var _textLabel: UILabel?
  @IBOutlet private weak var _detailsTextLabel: UILabel?
  
  override var textLabel: UILabel? {
    return _textLabel
  }
  
  override var detailTextLabel: UILabel? {
    return _detailsTextLabel
  }
  
  override var imageView: UIImageView? {
    return _imageView
  }
}
