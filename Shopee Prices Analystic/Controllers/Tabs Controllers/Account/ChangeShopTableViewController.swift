//
//  ChangeShopTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/23/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit


class ChangeShopTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var shopName: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        shopName.delegate = self
        password.delegate = self
        shopName.tag = 0
        password.tag = 1
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(15)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == shopName {
            password.becomeFirstResponder()
            return true
        }
        else {
            password.resignFirstResponder()
            connectToShopUsing(name: shopName.text!, pass: password.text!) {(name, pass) in
                return false
            }
            // Thực hiện kết nối tại đây
            return true
        }
    }
    
    
    // MARK: - Connect to Shop
    
    private func connectToShopUsing(name: String, pass: String, connectStatus: (String?, String?) -> Bool) {
        
        if !connectStatus(name, pass) {
            let alertController = UIAlertController(title: "Kết nối thất bại", message: "Tên shop hoặc mật khẩu không đúng", preferredStyle: .alert)
            let retyping = UIAlertAction(title: "Huỷ", style: .cancel, handler: {(action) in
                self.password.text = nil
            })
            
            alertController.addAction(retyping)
            alertController.popoverPresentationController?.sourceView = tableView
            present(alertController, animated: true, completion: {
                self.password.text = nil
            })
        }
    }
    
    private func textEqualToNil(shopName: UITextField, password: UITextField) -> Bool {
        if shopName.text == nil || password.text == nil {
            print("isNil is called")
            let alertController = UIAlertController(title: "Thông tin chưa nhập", message: "Bạn chưa nhập tên shop hoặc mật khẩu", preferredStyle: .alert)
            let retyping = UIAlertAction(title: "Huỷ", style: .cancel, handler: {(action) in
                self.password.text = nil
            })
            
            alertController.addAction(retyping)
            alertController.popoverPresentationController?.sourceView = tableView
            present(alertController, animated: true, completion: nil)
            return true
        }
        else {
            return false
        }
    }
}
