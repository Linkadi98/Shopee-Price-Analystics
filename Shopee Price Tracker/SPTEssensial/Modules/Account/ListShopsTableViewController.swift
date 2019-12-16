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
    
//    var isFirstAppear = true
    var hasData = false

    override func awakeFromNib() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(onInternetAccess(_:)), name: .internetAccess, object: nil)
        
        center.addObserver(self, selector: #selector(onNoInternetAccess(_:)), name: .noInternetAccess, object: nil)
    }
    
    @objc func onInternetAccess(_ notification: Notification) {
        guard vm != nil else {
            return
        }
    }
    
    @objc func onNoInternetAccess(_ notification: Notification) {
        guard vm != nil else {
            return
        }
        presentAlert(title: "Mất kết nối mạng", message: "Vui lòng kiểm tra kết nối mạng")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = true
        navigationItem.hidesSearchBarWhenScrolling = false
        setupSearchController(for: searchController, placeholder: "Nhập tên shop")

        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl?.tintColor = UIColor.blue
        
        tableView.register(UINib(nibName: "SPTShopCell", bundle: nil), forCellReuseIdentifier: "SPTShopCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        view.startSkeletonAnimation()

        guard listShops != nil, let currentShop = UserDefaults.standard.getObjectInUserDefaults(forKey: "currentShop") as? Shop, listShops![0] == currentShop else {
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
            return filterShop?.count ?? 0
        }
        return listShops?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SPTShopCell", for: indexPath) as! SPTShopCell

        
        guard listShops != nil, let currentShop = UserDefaults.standard.getObjectInUserDefaults(forKey: "currentShop") as? Shop else {
            return cell
        }

        var model: Shop

        if isFiltering(searchController) {
            model = filterShop![indexPath.row]
        }
        else {
            model = listShops![indexPath.row]
        }

        cell.configCell(shopName: model.name ?? "---", isCurrentShop: model.shopid == currentShop.shopid)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: tableView.rowHeight, duration: 0.3, delayFactor: 0.03)
//        let animator = Animator(animation: animation)
//        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard listShops != nil, let currentShop = UserDefaults.standard.getObjectInUserDefaults(forKey: "currentShop") as? Shop else {
            return
        }
        
        var model: Shop
        
        if isFiltering(searchController) {
            model = filterShop![indexPath.row]
        }
        else {
            model = listShops![indexPath.row]
        }
        
        if model.shopid != currentShop.shopid {
            changeCurrentShop(shop: model, indexPath: indexPath)
        }
        else {
            presentAlert(title: "Shop đã chọn", message: "Bạn có thể chọn shop khác") { _ in
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        
    }
    

    // MARK: - Search Actions
    
    func updateSearchResults(for searchController: UISearchController) {
        if hasData {
            filterContentForSearchText(searchController.searchBar.text!) {(searchText) in
                filterShop = listShops?.filter({(shop: Shop) -> Bool in
                    return shop.name!.lowercased().contains(searchText.lowercased())
                })
            }
        }
    }

    // MARK: - Fetching data from server
    private func fetchDataFromServer(isChangingShop: Bool = false) {
        
        tableView.allowsSelection = false

        ShopApiService.getListShops { [unowned self] (result, listShops) in
            guard result != .failed, var listShops = listShops else {
                self.hasData = false
                self.tableView.reloadData()
                self.displayNoDataNotification(title: "Không có dữ liệu, kiểm tra lại kết nối", message: "Shop của bạn sẽ hiện tại đây")
                return
            }

            guard !listShops.isEmpty else {
                self.hasData = false
                self.tableView.reloadData()
                self.displayNoDataNotification(title: "Tài khoản chưa có cửa hàng nào", message: "Nhấn vào biểu tượng để kết nối")
                return
            }

            guard let currentShop = UserDefaults.standard.getObjectInUserDefaults(forKey: "currentShop") as? Shop else {
                self.hasData = false
                
                self.tableView.reloadData()
                
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
                NotificationCenter.default.post(name: .didChangeCurrentShop, object: nil)
            }
            
            self.tableView.backgroundView = nil

            self.tableView.allowsSelection = true
            return
        }
    }

    private func changeCurrentShop(shop: Shop, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Chuyển sang \(String(describing: shop.name!))", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Huỷ", style: .destructive, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.saveObjectInUserDefaults(object: shop as AnyObject, forKey: "currentShop")
            self.fetchDataFromServer(isChangingShop: true)
        }))

        present(alert, animated: true, completion: {
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

                ShopApiService.addShop(shopId: shopId) { [unowned self] (result, message) in
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
