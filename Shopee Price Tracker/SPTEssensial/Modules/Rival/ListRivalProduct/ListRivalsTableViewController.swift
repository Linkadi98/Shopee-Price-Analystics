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
        
        tableView.register(UINib(nibName: CELL_XIB_NAME, bundle: nil), forCellReuseIdentifier: CELL_XIB_NAME)
        
        configVM()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        if let currentShopData = UserDefaults.standard.data(forKey: "currentShop"), let currentShop = try? JSONDecoder().decode(CustomerShop.self, from: currentShopData) {
        //            if vm?.product?.value.shopid != currentShop.shopid {
        //                self.navigationController?.popToRootViewController(animated: true)
        //            }
        //        }
        
        if vm?.listSearchedRivals?.value == nil {
            fetchDataFromServer()
        }
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vm?.listSearchedRivals?.value?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_XIB_NAME, for: indexPath) as! SPTCompetitorProductCell
        guard let listSearchedRivals = vm?.listSearchedRivals?.value, let listRivalShops =  vm?.listRivalShops?.value else {
            return cell
        }
        
        let rivalProduct = listSearchedRivals[indexPath.row].0
        let isSelected = listSearchedRivals[indexPath.row].1
        let rivalShop = listRivalShops[indexPath.row]
        
        cell.setContent(with: rivalProduct, shop: rivalShop, isSelectedToObserve: isSelected)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
                let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: tableView.rowHeight, duration: 0.3, delayFactor: 0.03)
                let animator = Animator(animation: animation)
                animator.animate(cell: cell, at: indexPath, in: tableView)
                tableView.scrollsToTop = true
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
    
    func configVM() {
        
        self.vm?.listSearchedRivals?.bind { listRivals in
            
            if self.result == .failed {
                self.displayNoDataNotification(title: "Có lỗi xảy ra", message: "Bạn hãy chắc chắn rằng thiết bị kết nối mạng", hudError: "Kết nối thất bại")
                print("list rival")
                self.tableView.reloadData()
                return
            }
            
            if listRivals!.isEmpty {
                self.displayNoDataNotification(title: "Không có sản phẩm tương tự", message: "Sản phẩm của bạn không có shop nào cùng bán", hudError: "Không tìm thấy")
                print("list rival 1")
                self.tableView.reloadData()
                return
            }
            
//            self.tableView.reloadData()
        }
        
        self.vm?.listRivalShops?.bind { listRivalShops in
            self.vm?.hud?.dismiss()
            if self.result == .failed {
                self.displayNoDataNotification(title: "Kết nối thất bại", message: "Bạn hãy chắc chắn rằng thiết bị kết nối mạng", hudError: "Kết nối thất bại")
                print("list rival shop")
                self.tableView.reloadData()
                return
            }
            
            if listRivalShops!.isEmpty {
                self.displayNoDataNotification(title: "Không tìm thấy sản phẩm nào tương tự", message: "", hudError: "Không tìm thấy")
                self.tableView.reloadData()
                print("list rival shop")
                return
            }
            
            self.tableView.reloadData()
        }
        vm?.hud = nil
        self.tableView.backgroundView = nil
    }
    
    private func fetchDataFromServer() {
        
        vm?.hud = SPTProgressHUD(style: .dark)
        vm?.hud?.show(in: tableView, content: "Đang tải")
        vm?.getListRivals(myProductId: vm?.product?.value.itemid ?? 0) { [unowned self] (result, listSearchedRivals) in
            
            guard result != .failed, let _listSearchedRivals = listSearchedRivals else {
                self.result = .failed
                self.vm?.listSearchedRivals?.value = []
                return
            }
            
            guard !_listSearchedRivals.isEmpty else {
                self.vm?.listSearchedRivals?.value = []
                return
            }
            
            self.vm?.listSearchedRivals?.value = _listSearchedRivals
        }
        
        vm?.getListRivalShops(myShopId: vm?.product?.value.shopid ?? 0, myProductId: vm?.product?.value.itemid ?? 0) { [unowned self] (listRivalsShops) in
            
            guard let _listRivalsShops = listRivalsShops else {
                self.result = .failed
                self.vm?.listRivalShops?.value = []
                return
            }
            
            guard !_listRivalsShops.isEmpty else {
                self.vm?.listRivalShops?.value = []
                return
            }
            
            self.vm?.listRivalShops?.value = _listRivalsShops
        }
        
    }
    
    @objc func refresh() {
        fetchDataFromServer()
        tableView.refreshControl?.endRefreshing()
    }
}
