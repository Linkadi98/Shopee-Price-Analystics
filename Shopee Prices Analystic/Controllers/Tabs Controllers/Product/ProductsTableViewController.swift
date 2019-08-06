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
        
        cell.productName.text = "\(product.name!)"
        cell.cosmos.rating = product.rating!
        cell.productPrice.text = product.convertPriceToVietnameseCurrency()
        cell.productCode.text = product.code!
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: tableView.rowHeight, duration: 0.3, delayFactor: 0.03)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
        
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product: Product
        if isFiltering(searchController) {
            product = filterProducts[indexPath.row]
        }
        else {
            product = products[indexPath.row]
        }
        performSegue(withIdentifier: "ProductDetail", sender: product)
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let cellSelected = tableView.cellForRow(at: indexPath)
        let editPriceButton = UITableViewRowAction(style: .default, title: "Sửa", handler: {(action, indexPath) in
            
        })
        
        return [editPriceButton]
    }


    // MARK: - Search Actions
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!) { (searchText) in
            filterProducts = products.filter({(product: Product) -> Bool in
                return product.name!.lowercased().contains(searchText.lowercased()) || product.code!.lowercased().contains(searchText.lowercased())
            })
        }
    }
    
    // MARK: - Actions
    
    @IBAction func editingMode(_ sender: Any) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
        }
        else {
            tableView.setEditing(true, animated: true)
        }
    }
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let product = sender as? Product else {
            return
        }
        
        if segue.identifier == "ProductDetail" {
            let vc = segue.destination as! ProductDetailTableViewController
            print("abc")
        }
    }
    
    // MARK: - Private modifications
    
    private func prepareProducts() -> [Product] {
        var list: [Product] = []
        for _ in 0...10 {
            list.append(Product(name: "Giày", code: "DAC1000256", price: 140000, rating: 5))
        }
        
        for _ in 0...10 {
            list.append(Product(name: "Ultra boost", code: "DAC2031564", price: 1300000, rating: 4.2))
        }
        return list
    }
}
