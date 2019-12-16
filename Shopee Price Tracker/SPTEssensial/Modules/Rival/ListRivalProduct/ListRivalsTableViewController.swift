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
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .didObserveRivalProduct, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .didCancelObserveRivalProduct, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if vm?.listSearchedRivals?.value.isEmpty ?? true {
            fetchDataFromServer()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vm?.listSearchedRivals?.value.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_XIB_NAME, for: indexPath) as! SPTCompetitorProductCell
        
        guard let values = vm?.listSearchedRivals?.value else {
            return cell
        }
        
        let rivalProduct = values[indexPath.row].0
        let rivalShop = values[indexPath.row].1
        let isSelected = values[indexPath.row].2
        
        
        
        cell.setContent(with: rivalProduct, shop: rivalShop, isSelectedToObserve: isSelected)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let values = vm?.listSearchedRivals?.value else {
            return
        }
        
        let value = values[indexPath.row]
        
        performSegue(withIdentifier: "rivalProductDetailSegue", sender: (value, vm?.product?.value))
       
    }
    
    func configVM() {
        self.vm?.listSearchedRivals?.bind { listRivals in
            self.vm?.hud?.dismiss()
            if self.result == .failed {
                self.displayNoDataNotification(title: "Có lỗi xảy ra", message: "", hudError: "Kết nối thất bại")
                
                self.tableView.reloadData()
                return
            }
            
            if listRivals.isEmpty {
                self.displayNoDataNotification(title: "Không tìm thấy sản phẩm cạnh tranh", message: "Sản phẩm của bạn không có shop nào cùng bán", hudError: "Không tìm thấy")
                self.tableView.reloadData()
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
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tuple = sender as! ((Product, Shop, Bool), Product)
        let value = tuple.0
        if segue.identifier == "rivalProductDetailSegue" {
            let vc = segue.destination as! RivalProductDetailViewController
            vc.vm = RivalProductDetailViewModel(rivalProduct: Observable(value.0),
                                                rivalShop: Observable(value.1), currentShopProduct: tuple.1, status: value.2)
            
        }
    }
    
    @objc func refresh() {
        fetchDataFromServer()
        tableView.refreshControl?.endRefreshing()
    }
}
