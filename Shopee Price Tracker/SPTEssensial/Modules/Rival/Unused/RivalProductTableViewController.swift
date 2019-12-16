//
//  RivalProductTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/7/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class RivalProductTableViewController: UITableViewController {

    var rival: Product?
    var dates: [String]?
    var prices: [Int]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl?.tintColor = UIColor.orange
    }

    override func viewDidAppear(_ animated: Bool) {
        update()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dates?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dates?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rivalProductCell", for: indexPath)

        guard let dates = dates, let prices = prices else {
//            presentAlert(title: "Lỗi không xác định", message: "Vui lòng thử lại sau") Vẫn đuợc gọi 1 lần
            return cell
        }

        let price = prices[indexPath.row]
        let date = dates[indexPath.row]

        cell.textLabel?.text = date
        cell.detailTextLabel?.text = price.convertPriceToVietnameseCurrency()!
        
//        cell.

        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
 
    @objc func refresh() {
        // Gọi api trả về kết quả trước reloadData()
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }

    func update() {
        PriceApiService.priceObservations(productId: (rival?.itemid)!) { (result, dates, prices) in
            print("669")
            if result == .failed {
                if dates!.isEmpty {
                    self.presentAlert(title: "Thông báo", message: "Sản phẩm chưa được ghi nhận lịch sử")
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    return
                }
            } else if result == .success {
                DispatchQueue.main.async {
                    self.dates = dates
                    self.prices = prices
                    self.tableView.reloadData()
                }
            }
        }
    }
}
