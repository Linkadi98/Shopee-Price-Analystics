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
   
    
    var listProducts: [Product] = []
    var filterProducts =  [Product]()
    var searchController: UISearchController!
    var height: CGFloat {
        let heightTop = UIApplication.shared.statusBarFrame.height + (
            (self.navigationController?.navigationBar.intrinsicContentSize.height) ?? 0)
        let heightBottom  = self.tabBarController?.tabBar.frame.height ?? 0
        return  UIScreen.main.bounds.height + (heightTop+heightBottom)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        setupSearchController(for: searchController, placeholder: "Nhập tên sản phẩm")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        UIApplication.shared.beginIgnoringInteractionEvents()

        let activityIndicator = initActivityIndicator()
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()

        getListProducts { (listProducts) in
            guard let listProducts = listProducts else {
                print("Khong co shop nao")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    activityIndicator.stopAnimating()
                    if activityIndicator.isAnimating == false {
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                }
                return
            }

            if !listProducts.isEmpty {
                self.listProducts = listProducts
                self.tableView.reloadData()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                activityIndicator.stopAnimating()
                if activityIndicator.isAnimating == false {
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
        return
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
        return listProducts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell
        let product: Product
        if isFiltering(searchController) {
            product = filterProducts[indexPath.row]
        }
        else {
            product = listProducts[indexPath.row]
        }
        
        cell.productName.text = "\(product.name!)"
        cell.cosmos.rating = product.rating!
        cell.productPrice.text = product.convertPriceToVietnameseCurrency()
        cell.productCode.text = product.id!
        loadOnlineImage(from: URL(string: product.image!)!, to: cell.productImage)

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
            product = listProducts[indexPath.row]
        }
        performSegue(withIdentifier: "ProductDetail", sender: product)
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let cellSelected = tableView.cellForRow(at: indexPath)
        let editPriceButton = UITableViewRowAction(style: .default, title: "Sửa", handler: {(action, indexPath) in
            
        })
        
        editPriceButton.backgroundColor = .blue
        
        return [editPriceButton]
    }


    // MARK: - Search Actions
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!) { (searchText) in
            filterProducts = listProducts.filter({(product: Product) -> Bool in
                return product.name!.lowercased().contains(searchText.lowercased()) || product.id!.lowercased().contains(searchText.lowercased())
            })
        }
    }
    
    // MARK: - Actions
    
    @IBAction func editingMode(_ sender: Any) {
        let tabVC = storyboard?.instantiateViewController(withIdentifier: "TabsViewController") as! TabsViewController
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            
        }
        else {
            tableView.setEditing(true, animated: true)
            tabVC.isSwipeEnabled = false
            tabVC.test()
        }
    }
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductDetail" {
            let vc = segue.destination as! ProductDetailTableViewController
            vc.product = sender as! Product
        }
    }
    
    // MARK: - Private modifications
    
//    private func prepareProducts() -> [Product] {
//        var list: [Product] = []
//        for _ in 0...10 {
//            list.append(Product(id: "DAC1000256", name: "Giày", price: 140000, rating: 5))
//        }
//        
//        for _ in 0...10 {
//            list.append(Product(id: "DAC2031564", name: "Ultra boost", price: 1300000, rating: 4.2))
//        }
//        return list
//    }
}

extension UIView {

    func centerInContainingWindow() {
        guard let window = self.window else { return }

        let windowCenter = CGPoint(x: window.frame.midX, y: window.frame.midY)
        self.center = self.superview!.convert(windowCenter, from: nil)
    }

}
