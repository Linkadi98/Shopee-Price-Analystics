//
//  ListShopsTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/18/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class ListShopsTableViewController: UITableViewController, UISearchResultsUpdating {

    // MARK: - Properties
    
    var data: [Shop] = []
    var filterShop: [Shop] = []
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = prepareShopInformation()
    
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = true
        setupSearchController(for: searchController, placeholder: "Nhập tên shop")
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(searchController) {
            return filterShop.count
        }
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath) as! ShopTableViewCell
        var model: Shop
        if isFiltering(searchController) {
            model = filterShop[indexPath.row]
        }
        else {
            model = data[indexPath.row]
        }
        
        cell.shopName.text = model.shopName
        cell.shopId.text = model.shopId

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: tableView.rowHeight, duration: 0.3, delayFactor: 0.03)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model: Shop

        if isFiltering(searchController) {
            model = filterShop[indexPath.row]
        }
        else {
            model = data[indexPath.row]
        }
        
        let customPasswordConfirmAlert = UIAlertController(title: "Chuyển sang \(model.shopName!)", message: "Vui lòng xác nhận trước khi chuyển sang Shop mới", preferredStyle: .alert)
        customPasswordConfirmAlert.createCustomPasswordConfirmAlert()
        present(customPasswordConfirmAlert, animated: true, completion: {
            // Chuyển về tab đầu tiên và hiện các thông tin của shop tại đây
            tableView.deselectRow(at: indexPath, animated: true)
        })
    }
    
    // MARK: - Search Actions
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!) {(searchText) in
            filterShop = data.filter({(shop: Shop) -> Bool in
                return shop.shopName!.lowercased().contains(searchText.lowercased())
            })
        }
    }
    
    

    // MARK: - Private Modification
    
    // đưa thông tin của shop từ api vào đây
    private func prepareShopInformation() -> [Shop] {
        var list: [Shop] = []
        for _ in 0...10 {
            list.append(Shop(shopName: "Shop123", shopId: "123456789"))
        }
        
        for _ in 0...5 {
            list.append(Shop(shopName: "AppleStore", shopId: "123456789"))
        }
        return list
    }
    
    
}
