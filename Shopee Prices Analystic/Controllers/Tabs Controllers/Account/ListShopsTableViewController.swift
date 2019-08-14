//
//  ListShopsTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/18/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import SkeletonView

class ListShopsTableViewController: UITableViewController, SkeletonTableViewDataSource, UISearchResultsUpdating {

    // MARK: - Properties
  
    var searchController: UISearchController!

    var listShops: [Shop]?
    var filterShop: [Shop]?
    var addedShopId: String?
    
    // Flag for regconizing tableview is appeared or not in order to display no data message
    var isFirstAppear = true
    var hasData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = true
        navigationItem.hidesSearchBarWhenScrolling = false
        setupSearchController(for: searchController, placeholder: "Nhập tên shop")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.startSkeletonAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        view.stopSkeletonAnimation()
        if listShops == nil {
            tableView.reloadData()
        }
    }
    

    override func viewDidAppear(_ animated: Bool) {
        if listShops != nil {
            return
        }
        fetchingDataFromServer()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(searchController) {
            return isFirstAppear ? filterShop?.count ?? 10 : 0
        }
        return isFirstAppear ? listShops?.count ?? 10 : 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath) as! ShopTableViewCell
        if listShops != nil {
            var model: Shop
            
            if isFiltering(searchController) {
                model = filterShop![indexPath.row]
            }
            else {
                model = listShops![indexPath.row]
            }
            
            cell.shopName.text = model.shopName
            cell.shopId.text = model.shopId
            cell.status.addImage(#imageLiteral(resourceName: "active"), "")
            cell.hideSkeletonAnimation()
        }
        

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("will display")
        let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: tableView.rowHeight, duration: 0.3, delayFactor: 0.03)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
        isFirstAppear = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model: Shop
        
        if isFiltering(searchController) {
            model = filterShop![indexPath.row]
        }
        else {
            model = listShops![indexPath.row]
        }
        
        let customPasswordConfirmAlert = UIAlertController(title: "Chuyển sang \(model.shopName)", message: "Vui lòng xác nhận trước khi chuyển sang Shop mới", preferredStyle: .alert)
        customPasswordConfirmAlert.createCustomPasswordConfirmAlert()
        present(customPasswordConfirmAlert, animated: true, completion: {
            // Chuyển về tab đầu tiên và hiện các thông tin của shop tại đây
            tableView.deselectRow(at: indexPath, animated: true)
        })
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "shopCell"
    }
    
    // MARK: - Search Actions
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!) {(searchText) in
            filterShop = listShops?.filter({(shop: Shop) -> Bool in
                return shop.shopName.lowercased().contains(searchText.lowercased())
            })
        }
    }

    // MARK: - Fetching data from server
    
    private func fetchingDataFromServer() {
        tableView.reloadData()
        
        view.hideSkeleton()
        view.showAnimatedSkeleton()
        
        tableView.allowsSelection = false
        
        getListShops { [unowned self] (listShops) in
            guard let listShops = listShops else {
                print("Khong co shop nao vi chua ket noi")
                
                self.displayNoDataNotification(text: "Shop của bạn sẽ hiện tại đây")
                self.isFirstAppear = false
                self.hasData = false
                self.tableView.reloadData()
                self.isFirstAppear = true
                return
            }
            
            if !listShops.isEmpty && !self.hasData {
                self.listShops = listShops
                self.tableView.reloadData()
            }
            
            self.view.hideSkeleton()
            self.view.stopSkeletonAnimation()
            self.tableView.backgroundView = nil
            
            self.tableView.allowsSelection = true
            return
        }
    }

    @IBAction func unwindToListShopsTableViewController(segue: UIStoryboardSegue) {
        print("unwind")
        if segue.identifier == "ShopeeAuthVCUnwindToListShopsTVC" {
            if let shopeeAuthViewController = segue.source as? ShopeeAuthViewController {
                if let result = shopeeAuthViewController.result {
                    if result == "failed" {
                        self.presentAlert(message: "Thêm cửa hàng thất bại")
                    }
                }
            }
        }
    }
}

