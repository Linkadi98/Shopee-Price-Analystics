//
//  CategoryTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/19/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class ProductsTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    // MARK: - Properties
   
    
    var products: [Product] = []
    var filterProducts =  [Product]()
    var searchController: UISearchController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        products = prepareProducts()
        
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        setupSearchController(for: searchController, placeholder: "Nhập tên sản phẩm")
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
        if isFiltering(searchController) {
            return filterProducts.count
        }
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell
        let product: Product
        if isFiltering(searchController) {
            product = filterProducts[indexPath.row]
        }
        else {
            product = products[indexPath.row]
        }
        
        cell.productNameLabel.text = "\(product.name!)"
        cell.cosmos.rating = product.rating!
        print("\(product.name!)\(indexPath.row)")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: tableView.rowHeight, duration: 0.3, delayFactor: 0.03)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        let subView = UIView()
        subView.alpha = 0
        UIView.animate(withDuration: 0.35, animations: {
            subView.alpha = 1
            self.view.addSubview(subView)
        })
    }

    // MARK: - Search Actions
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!) { (searchText) in
            filterProducts = products.filter({(product: Product) -> Bool in
                return product.name!.lowercased().contains(searchText.lowercased())
            })
        }
    }
    
    // MARK: - Private modifications
    
    private func prepareProducts() -> [Product] {
        var list: [Product] = []
        for _ in 0...10 {
            list.append(Product(name: "Giày", description: "Giày adidas superfake", price: 130000, rating: 5))
        }
        
        for _ in 0...10 {
            list.append(Product(name: "Ultra boost", description: "Giày adidas superfake", price: 130000, rating: 4.2))
        }
        return list
    }
}
