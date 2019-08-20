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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl?.tintColor = UIColor.orange
        
        tableView.separatorStyle = .none
    }


    override func viewWillAppear(_ animated: Bool) {
        view.startSkeletonAnimation()
        fetchDataFromServer()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard listRivals != nil, listRivalsShops != nil else {
            return 4
        }
        return self.listRivals!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RivalCell", for: indexPath) as! RivalTableCell
        guard listRivals != nil, listRivalsShops != nil else {
            cell.setUnfollowStatus()
            return cell
        }

        let rival = listRivals![indexPath.row]
        let rivalShop = listRivalsShops![indexPath.row]
        cell.productName.text = rival.name!
        cell.productPrice.text = String(rival.price!)
        loadOnlineImage(from: URL(string: rival.image!)!, to: cell.productImage)
        cell.rivalName.text = rivalShop.shopName
        cell.rivalRating.rating = rivalShop.rating
        cell.rivalCode.text = rivalShop.shopId
        cell.followersCount.text = "Theo dõi: \(String(rivalShop.followersCount))"

        cell.setUnfollowStatus()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 188.0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RivalTableCell
        cell.setFollowStatus()
        tabBarController?.selectedIndex = 3
        if let vc = tabBarController?.selectedViewController as? RivalPageViewController {
            vc.pageViewController?.select(index: 2)
        }
        
    }

    private func fetchDataFromServer() {
        view.hideSkeleton()
        view.showAnimatedSkeleton()

        var doneloadingRivals = false
        var doneloadingRivalsShops = false
        tableView.allowsSelection = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.getListRivals(myShopId: (self.product?.shopId)!, myProductId: (self.product?.id)!) { (listRivals) in
                guard let listRivals = listRivals else {
                    self.displayNoDataNotification(title: "Không có dữ liệu, kiểm tra lại kết nối", message: "Sản phẩm đối thủ sẽ hiện tại đây")
                    self.tableView.reloadData()
                    return
                }

                guard !listRivals.isEmpty else {
                    self.displayNoDataNotification(title: "Không tìm thấy đối thủ", message: "Rất tiếc, sản phẩm của bạn không tìm thấy đối thủ")
                    self.tableView.reloadData()
                    return
                }

                self.listRivals = listRivals
                doneloadingRivals = true
                if doneloadingRivals, doneloadingRivalsShops {
                    doneloadingRivals = false
                    doneloadingRivalsShops = false

                    self.tableView.reloadData()

                    self.view.hideSkeleton()
                    self.view.stopSkeletonAnimation()

                    self.tableView.backgroundView = nil
                    self.tableView.allowsSelection = true
                }
            }

            self.getListRivalsShops(myShopId: (self.product?.shopId)!, myProductId: (self.product?.id)!) { (listRivalsShops) in
                guard let listRivalsShops = listRivalsShops else {
                    self.displayNoDataNotification(title: "Không có dữ liệu, kiểm tra lại kết nối", message: "Sản phẩm đối thủ sẽ hiện tại đây")
                    self.tableView.reloadData()
                    return
                }

                guard !listRivalsShops.isEmpty else {
                    self.displayNoDataNotification(title: "Không tìm thấy đối thủ", message: "Rất tiếc, sản phẩm của bạn không tìm thấy đối thủ")
                    self.tableView.reloadData()
                    return
                }

                self.listRivalsShops = listRivalsShops
                doneloadingRivalsShops = true
                if doneloadingRivals, doneloadingRivalsShops {

                    doneloadingRivals = false
                    doneloadingRivalsShops = false

                    self.tableView.reloadData()

                    self.view.hideSkeleton()
                    self.view.stopSkeletonAnimation()

                    self.tableView.backgroundView = nil
                    self.tableView.allowsSelection = true
                }
            }
        }
    }

    @objc func refresh() {
        
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
}
