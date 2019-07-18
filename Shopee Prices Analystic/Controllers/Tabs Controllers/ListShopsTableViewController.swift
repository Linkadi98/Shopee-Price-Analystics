//
//  ListShopsTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/18/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class ListShopsTableViewController: UITableViewController {

    // MARK: - Properties
    
    @IBOutlet var listShopTable: UITableView!
    
    var data: [Shop] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        listShopTable.layer.cornerRadius = 10
        listShopTable.layer.masksToBounds = true
        
        data = prepareShopInformation()
        
        listShopTable.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        let model: Shop
        model = data[indexPath.row]
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellIdentifier")
        cell.textLabel?.text = model.shopName
        cell.detailTextLabel?.text = model.shopId

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        let model: Shop = data[indexPath.row]
        
        let alertController = UIAlertController(title: "Chuyển sang \(model.shopName!)?", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        
        let switchToChosenShop = UIAlertAction(title: "Xác nhận", style: .default, handler: { action in
            // Xử lý xác nhận ngắt kết nối với shop hiện tại và chuyển sang shop vừa được chọn
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(switchToChosenShop)
        alertController.popoverPresentationController?.sourceView = cell
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Private Modification
    private func prepareShopInformation() -> [Shop] {
        var list: [Shop] = []
        for _ in 0...10 {
            list.append(Shop(shopName: "Shop123", shopId: "123456789"))
        }
        return list
    }
}
