//
//  AccountTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/22/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(40)
    }
}
