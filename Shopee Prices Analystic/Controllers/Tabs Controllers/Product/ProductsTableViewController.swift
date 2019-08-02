//
//  CategoryTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/19/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class ProductsTableViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Properties
   
    
    var products: [Product] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        products = prepareProducts()
        
        let searchBarController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchBarController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(products.count)
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell
        
        let product: Product = products[indexPath.row]
//        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "categoryCell")
        cell.productNameLabel.text = "\(product.name!)\(indexPath.row)"
//        cell.productDescLabel.text = product.description
        // Configure the cell...

        cell.cosmos.rating = 5.0
        print("\(product.name!)\(indexPath.row)")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: tableView.rowHeight, duration: 0.3, delayFactor: 0.03)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ProductTableViewCell else {
            return
        }
        
        print(indexPath.row)
        let subView = UIView()
        subView.alpha = 0
        UIView.animate(withDuration: 0.35, animations: {
            subView.alpha = 1
            self.view.addSubview(subView)
        })
    }

    // MARK: - Acctions
    
    
    // MARK: - Private modifications
    
    private func prepareProducts() -> [Product] {
        var list: [Product] = []
        for _ in 0...20 {
            list.append(Product(name: "Giày", description: "Giày adidas superfake", price: 130000, rating: 5))
        }
        return list
    }
}
