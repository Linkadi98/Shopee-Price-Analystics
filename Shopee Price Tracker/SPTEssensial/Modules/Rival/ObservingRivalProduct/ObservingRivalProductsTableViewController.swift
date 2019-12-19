//
//  ObservingRivalProductsTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/9/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class ObservingRivalProductsTableViewController: UITableViewController {
    
    var vm: ObservingRivalProductViewModel?
    
    var hasRivalProducts = false
    
    let CELL_XIB_NAME = "SPTCompetitorProductCell"

    override func awakeFromNib() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(onInternetAccess(_:)), name: .internetAccess, object: nil)
        
        center.addObserver(self, selector: #selector(onNoInternetAccess(_:)), name: .noInternetAccess, object: nil)
    }
    
    @objc func onInternetAccess(_ notification: Notification) {
        guard vm != nil else {
            return
        }
        fetchDataFromServer()
    }
    
    @objc func onNoInternetAccess(_ notification: Notification) {
        guard vm != nil else {
            return
        }
        presentAlert(title: "Mất kết nối mạng", message: "Vui lòng kiểm tra kết nối mạng")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

         tableView.register(UINib(nibName: CELL_XIB_NAME, bundle: nil), forCellReuseIdentifier: CELL_XIB_NAME)
        
        configViewModel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(_:)), name: .didSwitchAutoUpdate, object: nil)
        
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchDataFromServer()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return vm?.rivalResponse?.value.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_XIB_NAME, for: indexPath) as! SPTCompetitorProductCell
        
        guard
            let rivalProduct = vm?.rivalResponse?.value[indexPath.row].itemRival,
            let rivalShop = vm?.rivalResponse?.value[indexPath.row].shopRival,
            let isSelectedToObserve = vm?.rivalResponse?.value[indexPath.row].relation?.auto
            else {
            print("Go to here")
            return cell
        }
        
        cell.setContent(with: rivalProduct, shop: rivalShop, isSelectedToObserve: isSelectedToObserve, status1: "Chỉnh giá", status2: "Không chỉnh giá")

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rivalResponse = vm?.rivalResponse?.value[indexPath.row]
        
        performSegue(withIdentifier: "containerRivalSegue", sender: rivalResponse)
    }
    
    func configViewModel() {
        self.vm?.rivalResponse?.bind { rivalProduct in
            self.vm?.hud?.dismiss()
            guard self.hasRivalProducts else {
                self.displayNoDataNotification(title: "Có lỗi xảy ra", message: "Kiểm tra lại kết nối", action: nil, hudError: "Lỗi kết nối")
                self.tableView.reloadData()
                return
            }
            guard !rivalProduct.isEmpty else {
                self.displayNoDataNotification(title: "Chưa theo dõi giá sản phẩm nào", message: "Chọn một sản phẩm cạnh tranh để theo dõi giá", action: nil, hudError: "Không tìm thấy")
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
        
        vm?.fetchDataFromServer { result, response in
            
            guard result != .failed, let response = response else {
                self.hasRivalProducts = false
                self.vm?.rivalResponse?.value = []
                return
            }
            
            if !response.isEmpty {
                self.hasRivalProducts = true
            }
            
            self.vm?.rivalResponse?.value = response
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let rivalResponse = sender as? RivalsResponse, segue.identifier == "containerRivalSegue" {
            let vc = segue.destination as! ContainerRivalInfoViewController
            vc.product = vm?.currentShopProduct
            vc.rivalResponse = rivalResponse
        }
    }
    
    @objc func refresh() {
        fetchDataFromServer()
        refreshControl?.endRefreshing()
    }
    
    @objc func reloadData(_ notification: Notification) {
        fetchDataFromServer()
        print("reload")
    }

}
