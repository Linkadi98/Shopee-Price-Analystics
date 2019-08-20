//
//  RivalProductTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/7/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class RivalProductTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl?.tintColor = UIColor.orange
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    /*
     Thực hiện làm mới dữ liệu tại đây
     Gọi api để trả về dữ liệu cho model sản phẩm đối thủ
     Sau khi đã có dữ liệu thay đổi cho mảng sản phẩm đối
     thủ, reloadData() sẽ được gọi và các cell sẽ được tự
     động rebuild, chú ý chỉ có các cell visible trên bảng
     sẽ được vẽ lại trước, các cell bị ẩn sẽ được vẽ lại
     như bình thường nhưng với dữ liệu mới
    */
    @objc func refresh() {
        // Gọi api trả về kết quả trước reloadData()
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
}
