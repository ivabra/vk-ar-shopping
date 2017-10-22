//
//  ProductListViewController.swift
//  AR Shopping
//
//  Created by Ivan Brazhnikov on 22.10.2017.
//  Copyright © 2017 Go About. All rights reserved.
//

import UIKit
import SDWebImage

final class ProductListViewController : BaseCompoundChildViewController {
  
  var shop: Shop! {
    didSet {
      if let title = shop.title {
        self.title = title
      }
    }
  }
  
  var products: [Product] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  @IBOutlet var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadProducts()
  }
  
  func loadProducts() {
    guard let shop = self.shop else { return }
    showHUD()
    Network.dispatch {
      defer {
        UI { [weak self] in
          self?.hideHUD()
        }
      }
      do {
        let products = try API.default.products(shopId: shop.id)
        UI { [weak self] in
          self?.products = products
        }
      } catch {
        print(error)
      }
    }
  }

}

extension ProductListViewController : UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCell
    let product = products[indexPath.item]
    cell.textLabel?.text = product.title
    cell.priceLabel?.text = product.price
    cell.detailTextLabel?.text = product.category
    cell.imageView?.sd_setImage(with: product.thumb_photo)
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    (segue.destination as? LoadingModelViewController)?.product = sender as? Product
  }
}

extension ProductListViewController : UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let product = products[indexPath.item]
    performSegue(withIdentifier: "product", sender: product)
  }
}

final class ProductCell: ShopListCell {
  @IBOutlet weak var priceLabel: UILabel!
}
