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
    var listRivals: [Product]?
    var listRivalsShops: [Shop]?

    var isFirstAppear = true
    var hasData = false

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
        
        if listRivals == nil && listRivalsShops == nil {
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
        
        return isFirstAppear ? listRivals?.count ?? 10 : 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RivalCell", for: indexPath) as! RivalTableCell
        guard listRivals != nil, listRivalsShops != nil else {
            return cell
        }

        let rival = listRivals![indexPath.row]
        let rivalShop = listRivalsShops![indexPath.row]
        cell.productName.text = rival.name!
        cell.productPrice.text = rival.convertPriceToVietnameseCurrency()
        loadOnlineImage(from: URL(string: rival.image!)!, to: cell.productImage)
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
        let rival = listRivals![indexPath.row]
        chooseRival(myProductId: (product?.id)!, myShopId: (product?.shopId)!, rivalProductId: rival.id!, rivalShopId: rival.shopId!) { (result) in
            if result == "success" {
                print("Choose rival OK")
            }
        }
        cell.setFollowStatus()
//        tabBarController?.selectedIndex = 3
        performSegue(withIdentifier: "listRivalSegue", sender: nil)
        
    }

    private func fetchDataFromServer() {
        tableView.reloadData()

        view.hideSkeleton()
        view.showAnimatedSkeleton()
        
        var doneloadingRivals = false
        var doneloadingRivalsShops = false
        tableView.allowsSelection = false
        getListRivals(myShopId: (product?.shopId)!, myProductId: (product?.id)!) { [unowned self] (listRivals) in
            guard let listRivals = listRivals else {
                self.displayNoDataNotification(title: "Không có dữ liệu, kiểm tra lại kết nối", message: "Sản phẩm đối thủ sẽ hiện tại đây")
                self.isFirstAppear = false
                self.hasData = false
                self.tableView.reloadData()
                self.isFirstAppear = true
                return
            }

            guard !listRivals.isEmpty else {
                self.displayNoDataNotification(title: "Không tìm thấy đối thủ", message: "Sản phẩm của bạn không có đối thủ nào cùng bán")
                self.isFirstAppear = false
                self.hasData = false
                self.tableView.reloadData()
                self.isFirstAppear = true
                return
            }

            self.listRivals = listRivals
            doneloadingRivals = true
            if doneloadingRivals, doneloadingRivalsShops {
                doneloadingRivals = false
                doneloadingRivalsShops = false

                self.tableView.reloadData()
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
