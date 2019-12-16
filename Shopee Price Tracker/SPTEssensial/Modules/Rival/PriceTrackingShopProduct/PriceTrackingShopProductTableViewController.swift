//
//  PriceTrackingShopProductTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/9/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class PriceTrackingShopProductTableViewController: UITableViewController {

    let OBSERVED_SHOP_PRODUCT_CELL = "SPTObservedShopProductCell"
    
    var vm: PriceTrackingShopProductViewModel?
    var connection = false
    
    override class func awakeFromNib() {
        let center = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(reloadData(_:)), name: .didChooseRival, object: nil)
        
        center.addObserver(self, selector: #selector(reloadData(_:)), name: .didSwitchAutoUpdate, object: nil)
        
        center.addObserver(self, selector: #selector(reloadData(_:)), name: .didChangeCurrentShop, object: nil)
        
        center.addObserver(self, selector: #selector(refresh), name: .internetAccess, object: nil)
       
        center.addObserver(self, selector: #selector(onNoInternetAccess(_:)), name: .noInternetAccess, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: OBSERVED_SHOP_PRODUCT_CELL, bundle: nil), forCellReuseIdentifier: OBSERVED_SHOP_PRODUCT_CELL)
        
        configViewModel(PriceTrackingShopProductViewModel(observedShopProduct: Observable([])))
        
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if vm?.observedShopProduct?.value.isEmpty ?? false {
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
        return vm?.observedShopProduct?.value.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OBSERVED_SHOP_PRODUCT_CELL, for: indexPath) as! SPTObservedShopProductCell
        
        if let product = vm?.observedShopProduct?.value[indexPath.row] {
            cell.configCell(with: product)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = vm?.observedShopProduct?.value[indexPath.row]
        
        performSegue(withIdentifier: "rivalParrentPageView", sender: product)
        
    }
    
    func configViewModel(_ vm: PriceTrackingShopProductViewModel) {
        self.vm = vm
        self.vm?.observedShopProduct?.bind { products in
            self.vm?.hud?.dismiss()
            guard !products.isEmpty else {
                self.displayNoDataNotification(title: "Bạn chưa có sản phẩm nào theo dõi giá", message: "Hãy chọn một sản phẩm trong cửa hàng để theo dõi giá", action: nil, hudError: "Chưa theo dõi giá sản phẩm nào")
                self.tableView.reloadData()
                return
            }
            
            guard self.connection else {
                self.displayNoDataNotification(title: "Có lỗi xảy ra", message: "Kiểm tra lại kết nối", action: nil, hudError: "Lỗi kết nối")
                self.tableView.reloadData()
                return
            }
            
            self.tableView.reloadData()
            self.tableView.backgroundView = nil
        }
    }
    
    func fetchDataFromServer() {
        vm?.hud = SPTProgressHUD(style: .dark)
        vm?.hud?.show(in: tableView, content: "Đang tải")
        vm?.fetchDataFromServer(completion: { (result, products) in
            guard result != .failed, let products = products else {
                self.connection = false
                self.vm?.observedShopProduct?.value = []
                return
            }
            
            if !products.isEmpty {
                self.connection = true
            }
            
            self.vm?.observedShopProduct?.value = products
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let _segue = "rivalParrentPageView"
        if _segue == segue.identifier {
            let vc = segue.destination as! RivalParrentContainterViewController
            vc.currentShopProduct = sender as? Product
        }
    }
    
    @objc func reloadData(_ notification: Notification) {
        guard vm?.observedShopProduct?.value != nil else {
            return
        }
        vm?.observedShopProduct?.value = []
        fetchDataFromServer()
    }
    
    @objc func refresh() {
        guard vm?.observedShopProduct?.value != nil else {
            return
        }
        vm?.observedShopProduct?.value = []
        fetchDataFromServer()
        refreshControl?.endRefreshing()
    }
    
    @objc func onNoInternetAccess(_ notification: Notification) {
        guard vm?.observedShopProduct != nil else {
            return
        }
        presentAlert(title: "Mất kết nối mạng", message: "Vui lòng kiểm tra kết nối mạng")
    }
}
