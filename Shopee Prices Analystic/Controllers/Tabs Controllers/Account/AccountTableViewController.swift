//
//  AccountTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/22/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class AccountTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var data: (UIImage?, String?, String?, String?, String?)
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    @IBAction func unWind(unWindSegue: UIStoryboardSegue) {
        
    }
    
    // MARK: - Actions
    
    
}
