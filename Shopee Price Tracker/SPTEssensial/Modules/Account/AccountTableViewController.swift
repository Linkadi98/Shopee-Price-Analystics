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
import Alamofire

class AccountTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var data: (UIImage?, String?, String?, String?, String?)
    
    override func awakeFromNib() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(onInternetAccess(_:)), name: .internetAccess, object: nil)
        
        center.addObserver(self, selector: #selector(onNoInternetAccess(_:)), name: .noInternetAccess, object: nil)
    }
    
    @objc func onInternetAccess(_ notification: Notification) {
        guard vm != nil else {
            return
        }
    }
    
    @objc func onNoInternetAccess(_ notification: Notification) {
        guard vm != nil else {
            return
        }
        presentAlert(title: "Mất kết nối mạng", message: "Vui lòng kiểm tra kết nối mạng")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {

        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(0)
    }
    // MARK: - Actions
}


