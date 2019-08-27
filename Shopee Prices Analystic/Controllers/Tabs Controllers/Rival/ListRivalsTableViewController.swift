//
//  ListRivalsTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/9/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import SkeletonView
import NotificationBannerSwift

class ListRivalsTableViewController: UITableViewController {

    var product: Product?
    var listSearchedRivals: [(Product, Bool)]?
    var listRivalsShops: [Shop]?

    var isFirstAppear = true
    var hasData = false
    var numberOfRivals: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl?.tintColor = UIColor.orange
        
        tableView.separatorStyle = .none
        
    }


    override func viewWillAppear(_ animated: Bool) {
        view.startSkeletonAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        if let currentShopData = UserDefaults.standard.data(forKey: "currentShop"), let currentShop = try? JSONDecoder().decode(Shop.self, from: currentShopData) {
            if product?.shopId != currentShop.shopId {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        if listSearchedRivals == nil && listRivalsShops == nil {
            isFirstAppear = true
            hasData = false
        }

        if !hasData {
            fetchDataFromServer()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return isFirstAppear ? listSearchedRivals?.count ?? 10 : 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RivalCell", for: indexPath) as! RivalTableCell
        guard let listSearchedRivals = listSearchedRivals, let listRivalsShops =  listRivalsShops else {
            return cell
        }

        let rival = listSearchedRivals[indexPath.row].0
        let isChosen = listSearchedRivals[indexPath.row].1
        let rivalShop = listRivalsShops[indexPath.row]
        cell.productName.text = rival.name
        cell.productPrice.text = rival.price.convertPriceToVietnameseCurrency()!
        if isChosen {
            cell.setFollowStatus()
            print("true113")
        } else {
            cell.setUnfollowStatus()
            print("false114")
        }
        loadOnlineImage(from: URL(string: rival.image)!, to: cell.productImage)
        cell.rivalName.text = rivalShop.shopName
        cell.rivalRating.rating = rivalShop.rating
        cell.followersCount.text = "\(String(rivalShop.followersCount))"

        cell.hideSkeletonAnimation()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 188.0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RivalTableCell
        guard let product = product, let listSearchedRivals = listSearchedRivals else {
            DispatchQueue.main.async {
                self.presentAlert(title: "Lỗi không xác định", message: "Vui lòng thử lại sau")
            }
            return
        }

        // is Chosen
        if listSearchedRivals[indexPath.row].1 {
            DispatchQueue.main.async {
                self.presentAlert(title: "Thông báo", message: "Sản phẩm đã được theo dõi")
            }
            return
        }

        if let numberOfRivals = numberOfRivals {
            guard numberOfRivals < 5 else {
                DispatchQueue.main.async {
                    self.presentAlert(message: "Tối đa chỉ theo dõi 5 đối thủ")
                }
                return
            }
        }

        let rival = listSearchedRivals[indexPath.row].0
        chooseRival(myProductId: product.id, myShopId: product.shopId, rivalProductId: rival.id, rivalShopId: rival.shopId, autoUpdate: false, priceDiff: 0, from: 0, to: 0) { (result) in
            if result == .success {
                cell.setFollowStatus()
//                self.performSegue(withIdentifier: "listRivalSegue", sender: nil)
                self.tabBarController?.selectedIndex = 3
            }
        }
    }

    private func fetchDataFromServer() {
        tableView.reloadData()

//        for row in 0...self.tableView.numberOfRows(inSection: 0) {
//            self.tableView.cellForRow(at: IndexPath(row: row, section: 0))?.isHidden = false
//        }

        view.hideSkeleton()
        view.showAnimatedSkeleton()
        
        var doneloadingRivals = false
        var doneloadingRivalsShops = false
        tableView.allowsSelection = false
        getListRivals(myShopId: (product?.shopId)!, myProductId: (product?.id)!) { [unowned self] (result, listSearchedRivals, numberOfRivals) in
            guard result != .failed, let listSearchedRivals = listSearchedRivals, let numberOfRivals = numberOfRivals else {
                self.displayNoDataNotification(title: "Không có dữ liệu, kiểm tra lại kết nối", message: "Sản phẩm đối thủ sẽ hiện tại đây")
                self.isFirstAppear = false
                self.hasData = false
                self.tableView.reloadData()
                self.isFirstAppear = true
                return
            }

            guard !listSearchedRivals.isEmpty else {
                self.displayNoDataNotification(title: "Không tìm thấy đối thủ", message: "Sản phẩm của bạn không có đối thủ nào cùng bán")
                self.isFirstAppear = false
                self.hasData = false
                self.tableView.reloadData()
                self.isFirstAppear = true
                return
            }

            self.listSearchedRivals = listSearchedRivals
            self.numberOfRivals = numberOfRivals
            doneloadingRivals = true
            if doneloadingRivals, doneloadingRivalsShops {
                doneloadingRivals = false
                doneloadingRivalsShops = false

                self.tableView.reloadData()
                self.navigationItem.title = "Danh sách đối thủ (\(numberOfRivals)/\(listSearchedRivals.count))"
                self.hasData = true
                self.view.hideSkeleton()
                self.view.stopSkeletonAnimation()

                self.tableView.backgroundView = nil
                self.tableView.allowsSelection = true
            }
        }

        getListRivalsShops(myShopId: (product?.shopId)!, myProductId: (product?.id)!) { [unowned self] (listRivalsShops) in
            guard let listRivalsShops = listRivalsShops else {
                self.displayNoDataNotification(title: "Không có dữ liệu, kiểm tra lại kết nối", message: "Sản phẩm đối thủ sẽ hiện tại đây")
                self.isFirstAppear = false
                self.hasData = false
                self.tableView.reloadData()
                self.isFirstAppear = true
                return
            }

            guard !listRivalsShops.isEmpty else {
                self.displayNoDataNotification(title: "Không tìm thấy đối thủ", message: "Sản phẩm của bạn không có đối thủ nào cùng bán")
                self.isFirstAppear = false
                self.hasData = false
                self.tableView.reloadData()
                self.isFirstAppear = true
                return
            }

            self.listRivalsShops = listRivalsShops
            doneloadingRivalsShops = true
            if doneloadingRivals, doneloadingRivalsShops {

                doneloadingRivals = false
                doneloadingRivalsShops = false

                self.tableView.reloadData()
                if let numberOfRivals = self.numberOfRivals {
                    self.navigationItem.title = "Danh sách đối thủ (\(numberOfRivals)/\(listRivalsShops.count))"
                }
                self.hasData = true
                self.view.hideSkeleton()
                self.view.stopSkeletonAnimation()

                self.tableView.backgroundView = nil
                self.tableView.allowsSelection = true
            }
        }
    }

    @objc func refresh() {
        fetchDataFromServer()
        tableView.refreshControl?.endRefreshing()
    }
}
