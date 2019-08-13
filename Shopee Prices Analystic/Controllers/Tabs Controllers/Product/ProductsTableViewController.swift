//
//  CategoryTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/19/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import SkeletonView

class ProductsTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, SkeletonTableViewDataSource {
    
    // MARK: - Properties
   
    var listProducts: [Product]?
    var filterProducts: [Product]?
    var searchController: UISearchController!
    
    var isFirstAppear = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        setupSearchController(for: searchController, placeholder: "Nhập tên sản phẩm")
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl?.tintColor = UIColor.orange
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchingDataFromServer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        view.stopSkeletonAnimation()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.startSkeletonAnimation()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering(searchController) {
            return isFirstAppear ? filterProducts?.count ?? 10 : 0
        }
        return isFirstAppear ? listProducts?.count ?? 10 : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell
        let product: Product
        
        if listProducts != nil {
            
            if isFiltering(searchController) {
                product = filterProducts![indexPath.row]
            }
            else {
                product = listProducts![indexPath.row]
            }
            
            cell.productName.text = "\(product.name!)"
            cell.cosmos.rating = product.rating!
            cell.productPrice.text = product.convertPriceToVietnameseCurrency()
            cell.productCode.text = product.id!
            loadOnlineImage(from: URL(string: product.image!)!, to: cell.productImage)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !view.isSkeletonable || !view.isSkeletonActive {
            let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: tableView.rowHeight, duration: 0.3, delayFactor: 0.03)
            let animator = Animator(animation: animation)
            animator.animate(cell: cell, at: indexPath, in: tableView)
        }
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product: Product
        
        if listProducts != nil {
            if isFiltering(searchController) {
                product = filterProducts![indexPath.row]
            }
            else {
                product = listProducts![indexPath.row]
            }
            performSegue(withIdentifier: "ProductDetail", sender: product)
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let editPriceButton = UITableViewRowAction(style: .default, title: "Sửa", handler: {(action, indexPath) in
            
        })
        
        editPriceButton.backgroundColor = .blue
        
        return [editPriceButton]
    }
    
    // MARK: - Skeleton data source
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "productTableCell"
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }


    // MARK: - Search Actions
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!) { (searchText) in
            filterProducts = listProducts?.filter({(product: Product) -> Bool in
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
            view.hideSkeleton()
        }
    }
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductDetail" {
            let vc = segue.destination as! ProductDetailTableViewController
            vc.product = (sender as! Product)
        }
    }
    
    // MARK: - Refesh data
    
    @objc func refresh() {
        fetchingDataFromServer()
        tableView.refreshControl?.endRefreshing()
    }
    
    // MARK: - Private loading data for this class
    
    private func fetchingDataFromServer() {
        view.hideSkeleton()
        view.showAnimatedSkeleton()
        
        tableView.allowsSelection = false
        
        getListProducts { (listProducts) in
            guard let listProducts = listProducts else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [unowned self] in
                    self.displayNoDataNotification()
                    self.isFirstAppear = false
                    self.tableView.reloadData()
                    self.isFirstAppear = true
                }
                return
            }
            
            self.listProducts = listProducts
            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [unowned self] in
                self.view.hideSkeleton()
                self.view.stopSkeletonAnimation()
                self.tableView.allowsSelection = true
            }
            return
        }
    }
    
}

extension UIView {

    func centerInContainingWindow() {
        guard let window = self.window else { return }

        let windowCenter = CGPoint(x: window.frame.midX, y: window.frame.midY)
        self.center = self.superview!.convert(windowCenter, from: nil)
    }

}
