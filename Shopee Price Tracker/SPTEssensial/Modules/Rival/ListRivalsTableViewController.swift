//
//  ListRivalsTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/9/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class ListRivalsTableViewController: UITableViewController {
    
    var vm: ListRivalsViewModel?
    let CELL_XIB_NAME = "SPTCompetitorProductCell"
    
    var result: ConnectionResults?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl?.tintColor = UIColor.systemBlue
        
        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: CELL_XIB_NAME, bundle: nil), forCellReuseIdentifier: CELL_XIB_NAME)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let currentShopData = UserDefaults.standard.data(forKey: "currentShop"), let currentShop = try? JSONDecoder().decode(CustomerShop.self, from: currentShopData) {
            if vm?.product?.value.shopid != currentShop.shopid {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        if vm?.listSearchedRivals == nil {
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
        
        return vm?.listSearchedRivals?.value.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_XIB_NAME, for: indexPath) as! SPTCompetitorProductCell
        guard let listSearchedRivals = vm?.listSearchedRivals, let listRivalShops =  vm?.listRivalShops else {
            return cell
        }
        
        let rivalProduct = listSearchedRivals.value[indexPath.row].0
        let isChosen = listSearchedRivals.value[indexPath.row].1
        let rivalShop = listRivalShops.value[indexPath.row]
        
        cell.competitorProductName.text = rivalProduct.name
        cell.competitorProductPrice.text = String(describing: rivalProduct.price)
        cell.competitorName.text = rivalShop.shopName
        cell.changeFollowingStatus(isSelectedToObserve: isChosen)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SPTCompetitorProductCell
        guard let product = vm?.product?.value, let listSearchedRivals = vm?.listSearchedRivals?.value else {
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
        
        //        if let numberOfRivals = numberOfRivals {
        //            guard numberOfRivals < 5 else {
        //                DispatchQueue.main.async {
        //                    self.presentAlert(message: "Tối đa chỉ theo dõi 5 đối thủ")
        //                }
        //                return
        //            }
        //        }
        
        let rival = listSearchedRivals[indexPath.row].0
        vm?.chooseRival(myProductId: product.itemid!, myShopId: product.shopid!, rivalProductId: rival.itemid!, rivalShopId: rival.shopid!, autoUpdate: false, priceDiff: 0, from: 0, to: 0) { (result) in
            if result == .success {
                cell.changeFollowingStatus(isSelectedToObserve: true)
                NotificationCenter.default.post(name: .didChooseRival, object: nil)
                self.tabBarController?.selectedIndex = 3
            }
        }
    }
    
    func configVM(_ vm: ListRivalsViewModel) {
        self.vm = vm
        self.vm?.listSearchedRivals?.bind { listRivals in
            if self.result == .failed {
                self.displayNoDataNotification(title: "Không có dữ liệu, kiểm tra lại kết nối", message: "Sản phẩm đối thủ sẽ hiện tại đây")
                
                self.tableView.reloadData()
                return
            }
            
            if listRivals.isEmpty {
                self.displayNoDataNotification(title: "Không tìm thấy đối thủ", message: "Sản phẩm của bạn không có đối thủ nào cùng bán")
                self.tableView.reloadData()
                return
            }
        }
        
        self.vm?.listRivalShops?.bind { listRivalShops in
            
            if self.result == .failed {
                self.displayNoDataNotification(title: "Không có dữ liệu, kiểm tra lại kết nối", message: "Sản phẩm đối thủ sẽ hiện tại đây")
                
                self.tableView.reloadData()
                return
            }
            
            if listRivalShops.isEmpty {
                self.displayNoDataNotification(title: "Không tìm thấy đối thủ", message: "Sản phẩm của bạn không có đối thủ nào cùng bán")
                self.tableView.reloadData()
                return
            }
        }
    }
    
    private func fetchDataFromServer() {
        tableView.reloadData()
        
        tableView.allowsSelection = false
        vm?.getListRivals(myShopId: (vm?.product?.value.shopid)!, myProductId: (vm?.product?.value.itemid)!) { [unowned self] (result, listSearchedRivals) in
            guard result != .failed, let listSearchedRivals = listSearchedRivals else {
                self.result = .failed
                self.vm?.listSearchedRivals?.value = []
                return
            }
            
            guard !listSearchedRivals.isEmpty else {
                self.vm?.listSearchedRivals?.value = []
                return
            }
            
            
            self.tableView.backgroundView = nil
            self.tableView.allowsSelection = true
        }
        
        
        vm?.getListRivalShops(myShopId: (vm?.product?.value.shopid)!, myProductId: (vm?.product?.value.itemid)!) { [unowned self] (listRivalsShops) in
            guard let listRivalsShops = listRivalsShops else {
                self.result = .failed
                self.vm?.listRivalShops?.value = []
                
                return
            }
            
            guard !listRivalsShops.isEmpty else {
                self.vm?.listRivalShops?.value = []
                return
            }
            self.tableView.backgroundView = nil
            self.tableView.allowsSelection = true
        }
    }
    
    @objc func refresh() {
        fetchDataFromServer()
        tableView.refreshControl?.endRefreshing()
    }
}
