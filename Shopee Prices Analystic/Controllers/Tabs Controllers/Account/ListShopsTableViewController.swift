//
//  ListShopsTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/18/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import SkeletonView
import Alamofire
import NotificationBannerSwift

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

        print("Danh sach xyz: \(listShops)")
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
        print("Danh sach abc: \(listShops)")
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
            if (indexPath.row == 0) {
                cell.status.addImage(#imageLiteral(resourceName: "active"), "", x: -1)
                cell.selectionStyle = .none
            } else {
                cell.status.isHidden = true
            }
            cell.hideSkeletonAnimation()
        }
        

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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
        
        if indexPath.row != 0 {
            let customPasswordConfirmAlert = UIAlertController(title: "Chuyển sang \(model.shopName)", message: "Vui lòng xác nhận trước khi chuyển sang Shop mới", preferredStyle: .alert)
            customPasswordConfirmAlert.addTextField(configurationHandler: {(passwordField) in
                passwordField.placeholder = "Nhập mật khẩu của shop"
                passwordField.isSecureTextEntry = true

                passwordField.borderStyle = .none

            })
            customPasswordConfirmAlert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { _ in
                print("Đã huỷ")
            }))
            customPasswordConfirmAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                let activityIndicator = self.initActivityIndicator()
                self.view.addSubview(activityIndicator)
                activityIndicator.startAnimating()

                if let currentUserData = UserDefaults.standard.data(forKey: "currentUser"), let currentUser = try? JSONDecoder().decode(User.self, from: currentUserData) {
                    self.checkAccount(username: currentUser.name!, password: customPasswordConfirmAlert.textFields![0].text!, completion: { result in
                        if result == "wrong" {
                            self.presentAlert(message: "Sai mật khẩu")
                        } else if result == "success" {
                            self.changeCurrentShop(newShop: model)
                            self.hasData = false
                            self.fetchingDataFromServer() {
                                self.tabBarController?.selectedIndex = 0
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                            activityIndicator.stopAnimating()
                            if activityIndicator.isAnimating == false {
                                UIApplication.shared.endIgnoringInteractionEvents()
                            }
                        }
                    })
                }
            }))
            present(customPasswordConfirmAlert, animated: true, completion: {
                // Chuyển về tab đầu tiên và hiện các thông tin của shop tại đây
                tableView.deselectRow(at: indexPath, animated: true)
            })
//            if let userData = UserDefaults.standard.data(forKey: "currentUser"), let currentUser = try? JSONDecoder().decode(User.self, from: userData) {
//                customPasswordConfirmAlert.createCustomPasswordConfirmAlert(viewController: self, username: currentUser.name!, shop: model)
//                present(customPasswordConfirmAlert, animated: true, completion: {
//                    // Chuyển về tab đầu tiên và hiện các thông tin của shop tại đây
//                    tableView.deselectRow(at: indexPath, animated: true)
//                })
//            }
        }
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
    
    private func fetchingDataFromServer(completionAfterChangeShop completion: (() -> Void)? = nil) {
        tableView.reloadData()
        
        view.hideSkeleton()
        view.showAnimatedSkeleton()
        
        tableView.allowsSelection = false
        
        getListShops { [unowned self] (listShops) in
            guard var listShops = listShops else {
                print("1a")
                self.displayNoDataNotification(title: "Không có dữ liệu, kiểm tra lại kết nối", message: "Shop của bạn sẽ hiện tại đây")
                self.isFirstAppear = false
                self.hasData = false
                self.tableView.reloadData()
                self.isFirstAppear = true
                return
            }

            guard !listShops.isEmpty else {
                self.displayNoDataNotification(title: "Tài khoản chưa có cửa hàng nào", message: "Ấn vào biểu tượng để kết nối")
                self.isFirstAppear = false
                self.hasData = false
                self.tableView.reloadData()
                self.isFirstAppear = true
                return
            }
            
            if !self.hasData {
                if let currentShopData = UserDefaults.standard.data(forKey: "currentShop"), let currentShop = try? JSONDecoder().decode(Shop.self, from: currentShopData) {
                    let currentShopIndex = listShops.firstIndex(of: currentShop)!
                    listShops.swapAt(0, currentShopIndex)
                }
                self.listShops = listShops
                self.hasData = true
                self.tableView.reloadData()
                if completion != nil {
                    completion!()
                }
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
                        presentAlert(message: "Thêm cửa hàng thất bại")
                    } else if result == "success" {
                        self.hasData = false
                        let currentNumberOfRows = tableView.numberOfRows(inSection: 0)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                            self.fetchingDataFromServer()
                            print("DMDM: \(self.tableView.numberOfRows(inSection: 0))")
                            if self.tableView.numberOfRows(inSection: 0) > currentNumberOfRows {
                                self.presentAlert(title: "Thông báo", message: "Đã thêm thành công")
                            }
                        }

                    }
                }
            }
        }
    }
}

extension ListShopsTableViewController {
    
}
