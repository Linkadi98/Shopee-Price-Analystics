//
//  AutoUpdatePriceHistoryTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/26/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class AutoUpdatePriceHistoryTableViewController: UITableViewController {
    
    // MARK: - Properties
    var product: Product?
    var autoUpdateHistory: [AutoUpdateHistory]?
    
    override func awakeFromNib() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(onInternetAccess(_:)), name: .internetAccess, object: nil)
        
        center.addObserver(self, selector: #selector(onNoInternetAccess(_:)), name: .noInternetAccess, object: nil)
    }
    
    @objc func onInternetAccess(_ notification: Notification) {
        if product == nil {
            return
        }
        update()
    }
    
    @objc func onNoInternetAccess(_ notification: Notification) {
        
        presentAlert(title: "Mất kết nối mạng", message: "Vui lòng kiểm tra kết nối mạng")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        update()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return autoUpdateHistory?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return autoUpdateHistory?[section].date ?? nil
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! AutoUpdateHistoryCell
        
        guard let autoUpdateHistory = autoUpdateHistory else {
            return cell
        }
        let section = indexPath.section
        
        DispatchQueue.main.async {
            cell.rivalName.text = "Đ.thủ: " + (autoUpdateHistory[section].shopRival ?? "")
            cell.newPrice.text = autoUpdateHistory[section].price?.convertPriceToVietnameseCurrency() ?? ""
            cell.oldPrice.text = autoUpdateHistory[section].oldPrice?.convertPriceToVietnameseCurrency() ?? ""
            if let price = autoUpdateHistory[section].price, let oldPrice = autoUpdateHistory[section].oldPrice {
                if price > oldPrice {
                    cell.increasePriceImage()
                    cell.differentPrice.text = (price - oldPrice).convertPriceToVietnameseCurrency()
                }
                else {
                    cell.decreasePriceImage()
                    cell.differentPrice.text = (oldPrice - price).convertPriceToVietnameseCurrency()
                }
                
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    private func update() {
        PriceApiService.getAutoUpdateHistory(product: product!) { (result, autoUpdateHistory) in
            if result == .success {
                DispatchQueue.main.async {
                    self.autoUpdateHistory = autoUpdateHistory
                    if autoUpdateHistory!.isEmpty {
                        self.presentAlert(title: "Thông báo", message: "Chưa ghi nhận lịch sử")
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}
