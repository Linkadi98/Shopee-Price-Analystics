//
//  ListRivalsTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/9/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import SkeletonView

class ListRivalsTableViewController: UITableViewController {

    var product: Product?
    var listRivals: [Product]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl?.tintColor = UIColor.orange
        
        tableView.separatorStyle = .none
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard listRivals != nil else {
            return 4
        }
        return self.listRivals!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RivalCell", for: indexPath) as! RivalTableCell
        guard listRivals != nil else {
            cell.setUnfollowStatus()
            return cell
        }

        let rival = listRivals![indexPath.row]
        cell.productName.text = rival.name!
        cell.productPrice.text = String(rival.price!)
        loadOnlineImage(from: URL(string: rival.image!)!, to: cell.productImage)

        cell.setUnfollowStatus()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 188.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDataFromServer()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RivalTableCell
        cell.setFollowStatus()
        tabBarController?.selectedIndex = 3
        if let vc = tabBarController?.selectedViewController as? RivalPageViewController {
            vc.pageViewController?.select(index: 2)
        }
        
    }

    func fetchDataFromServer() {
        getListRivals(shopId: (product?.shopId)!, productId: (product?.id)!) { (listRivals) in
            self.listRivals = listRivals!
            self.tableView.reloadData()
        }
    }

    @objc func refresh() {
        
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
}
