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

    @IBAction func unWind(unWindSegue: UIStoryboardSegue) {
        
    }
    
    // MARK: - Actions
    
    
}

extension AccountTableViewController {
    func connectShop() {
        let url = URL(string: " http://192.168.36.28:8081/shopee")!

        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding(options: []), headers: Configuration.HEADERS).responseString { (response) in
            print(response.result)
            guard response.result.isSuccess else {
                print("Error when fetching data: \(response.result.error)")
                return
            }

            let redirectUrl = URL(string: response.result.value!)!
            UIApplication.shared.open(redirectUrl)
        }
    }
}
