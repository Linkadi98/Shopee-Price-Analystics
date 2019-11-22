//
//  ListShopsTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/18/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import Alamofire
import NotificationBannerSwift

class ListShopsTableViewController: UITableViewController, UISearchResultsUpdating {

    // MARK: - Properties
    var searchController: UISearchController!

    var listShops: [Shop]?
    var filterShop: [Shop]?
    
    var isFirstAppear = true
    var hasData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = true
        navigationItem.hidesSearchBarWhenScrolling = false
        setupSearchController(for: searchController, placeholder: "Nhập tên shop")

        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl?.tintColor = UIColor.orange
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        view.startSkeletonAnimation()

        guard listShops != nil, let currentShop = getObjectInUserDefaults(forKey: "currentShop") as? Shop, listShops![0] == currentShop else {
            fetchDataFromServer()
            return
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
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

        guard listShops != nil else {
            return cell
        }

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
//        cell.hideSkeletonAnimation()
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
            model = filterShop![indexPath.row]
        }
        else {
            model = listShops![indexPath.row]
        }
        
        if indexPath.row != 0 {
            changeCurrentShop(shop: model, indexPath: indexPath)
        }
    }
    
//    func numSections(in collectionSkeletonView: UITableView) -> Int {
//        return 1
//    }
//
//    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
//        return "shopCell"
//    }
    
    // MARK: - Search Actions
    
    func updateSearchResults(for searchController: UISearchController) {
        if hasData {
            filterContentForSearchText(searchController.searchBar.text!) {(searchText) in
                filterShop = listShops?.filter({(shop: Shop) -> Bool in
                    return shop.shopName.lowercased().contains(searchText.lowercased())
                })
            }
        }
    }

    // MARK: - Fetching data from server
    private func fetchDataFromServer(isChangingShop: Bool = false) {
        
//        view.hideSkeleton()
//        view.showAnimatedSkeleton()
        
        tableView.allowsSelection = false

        getListShops { [unowned self] (result, listShops) in
            guard result != .failed, var listShops = listShops else {
                self.hasData = false
                self.isFirstAppear = true
                self.tableView.reloadData()
                self.isFirstAppear = false
                self.displayNoDataNotification(title: "Không có dữ liệu, kiểm tra lại kết nối", message: "Shop của bạn sẽ hiện tại đây")
                return
            }

            guard !listShops.isEmpty else {
                self.hasData = false
                self.isFirstAppear = true
                self.tableView.reloadData()
                self.isFirstAppear = false
                self.displayNoDataNotification(title: "Tài khoản chưa có cửa hàng nào", message: "Nhấn vào biểu tượng để kết nối")
                return
            }

            guard let currentShop = self.getObjectInUserDefaults(forKey: "currentShop") as? Shop else {
                self.hasData = false
                self.isFirstAppear = true
                self.tableView.reloadData()
                self.isFirstAppear = false
                self.displayNoDataNotification(title: "Không có dữ liệu, kiểm tra lại kết nối", message: "Shop của bạn sẽ hiện tại đây")
                return
            }

            let currentShopIndex = listShops.firstIndex(of: currentShop)!
            listShops.swapAt(0, currentShopIndex)
            self.hasData = true
            DispatchQueue.main.async {
                self.listShops = listShops
                self.tableView.reloadData()
            }

            if isChangingShop {
                self.tabBarController?.selectedIndex = 0
                
            }
            
//            self.view.hideSkeleton()
//            self.view.stopSkeletonAnimation()
            self.tableView.backgroundView = nil

            self.tableView.allowsSelection = true
            return
        }
    }

    private func changeCurrentShop(shop: Shop, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Chuyển sang \(shop.shopName)", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { _ in
            print("Đã huỷ")
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.saveObjectInUserDefaults(object: shop as AnyObject, forKey: "currentShop")
            self.fetchDataFromServer(isChangingShop: true)
        }))

        present(alert, animated: true, completion: {
            // Chuyển về tab đầu tiên và hiện các thông tin của shop tại đây
            self.tableView.deselectRow(at: indexPath, animated: true)
        })

    }

    @IBAction func unwindToListShopsTableViewController(segue: UIStoryboardSegue) {
        if segue.identifier == "ShopeeAuthVCUnwindToListShopsTVC" {
            if let shopeeAuthViewController = segue.source as? ShopeeAuthViewController {
                guard let shopId = shopeeAuthViewController.shopId else {
                    presentAlert(message: "Lỗi xác thực. Vui lòng thử lại sau")
                    return
                }

                let activityIndicator = startLoading()

                addShop(shopId: shopId) { [unowned self] (result, message) in
                    switch result {
                    case .error:
                        self.presentAlert(message: message!)
                    case .success:
                        self.fetchDataFromServer()
                        self.presentAlert(title: "Thông báo", message: message!)
                    default:
                        break
                    }

                    self.endLoading(activityIndicator)
                }
            }
        }
    }

    // MARK: - Refesh data
    @objc func refresh() {
        fetchDataFromServer()
        tableView.refreshControl?.endRefreshing()
    }
}
