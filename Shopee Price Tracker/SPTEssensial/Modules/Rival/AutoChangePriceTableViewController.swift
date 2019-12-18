//
//  AutoChangePriceTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/14/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class AutoChangePriceTableViewController: UITableViewController, UITextFieldDelegate {

    // MARK: - Properties
//    var product: Product?
//    var rivalProduct: Product?
    var rivalResponse: RivalsResponse? // current
        
    @IBOutlet weak var autoChangePriceSwitch: UISwitch!
    @IBOutlet weak var minPriceRange: UITextField!
    @IBOutlet weak var maxPriceRange: UITextField!
    @IBOutlet weak var priceDiff: UITextField!
    

//    var rivalProducts: [Product]?

    
    override func awakeFromNib() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(onInternetAccess(_:)), name: .internetAccess, object: nil)
        
        center.addObserver(self, selector: #selector(onNoInternetAccess(_:)), name: .noInternetAccess, object: nil)
    }
    
    @objc func onInternetAccess(_ notification: Notification) {
        
    }
    
    @objc func onNoInternetAccess(_ notification: Notification) {
        presentAlert(title: "Mất kết nối mạng", message: "Vui lòng kiểm tra kết nối mạng")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        minPriceRange.keyboardType = .numberPad
        maxPriceRange.keyboardType = .numberPad
        priceDiff.keyboardType = .numberPad

        autoChangePriceSwitch.isOn = false
        
        hideKeyboardWhenTappedAround()
        registerKeyboardForNotification()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }

    @IBAction func switchAutoChangePrice(_ sender: Any) {
        tableView.beginUpdates()
        tableView.endUpdates()

        // Turn off auto updating
        if rivalResponse?.relation?.auto == true {
            if !autoChangePriceSwitch.isOn {
                let alert = UIAlertController(title: "Bạn muốn tắt chỉnh giá tự động?", message: nil, preferredStyle: .alert)
                let cancelButton = UIAlertAction(title: "Huỷ", style: .destructive) { _ in
                    self.autoChangePriceSwitch.isOn = true
                }
                let okButton = UIAlertAction(title: "OK", style: .default) { (_) in
                    let activityIndicator = self.startLoading()

                    RivalApiService.chooseRival(myProductId: (self.rivalResponse?.itemRival?.itemid)!, myShopId: (self.rivalResponse?.relation?.shopid)!, rivalProductId: (self.rivalResponse?.itemRival?.itemid)!, rivalShopId: (self.rivalResponse?.itemRival?.shopid)!, autoUpdate: false, priceDiff: 0, from: 0, to: 0, completion: { (result) in
                        if result == .success {
                            self.presentAlert(title: "Thông báo", message: "Tắt thành công")

                            NotificationCenter.default.post(name: .didSwitchAutoUpdate, object: nil, userInfo: nil)
                        }
                        self.endLoading(activityIndicator)
                    })
                }

                alert.addAction(cancelButton)
                alert.addAction(okButton)
                present(alert, animated: true, completion: nil)
                maxPriceRange.text = ""
                minPriceRange.text = ""
                priceDiff.text = ""
            }
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        
        if indexPath.row == 1 {
            return indexPath
        }
        return nil
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row != 0 && !autoChangePriceSwitch.isOn {
            return 0.0
        }
        return 60.0
    }
    
    // MARK: - Textfield delegate
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
////        switch textField.tag {
////        case 0:
////            print("min")
////        case 1:
////            print("max")
////        case 2:
////            print("diff")
////        default:
////            break
////        }
////        if minPriceRange.isFirstResponder {
////            maxPriceRange.becomeFirstResponder()
////            return false
////        }
////        else {
////            maxPriceRange.resignFirstResponder()
////            return true
////        }
//        let (result, message) = checkTextFields()
//        guard result else {
//            self.presentAlert(message: message)
//            return true
//        }
//
//        textField.resignFirstResponder()
//
//        return true
//    }

    private func checkTextFields() -> (Bool, String) {
        guard let maxPrice = UInt(maxPriceRange.text!), let minPrice = UInt(minPriceRange.text!), let _ = UInt(priceDiff.text!) else {
            return (false, "Xin mời nhập đúng giá")
        }

        guard maxPrice > minPrice else {
            return (false, "Khoảng giá không hợp lệ")
        }

        return (true, "OK")
    }
    
    
    // MARK: - Keyboard issues
    private func registerKeyboardForNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillbeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    @objc private func keyboardWasShown(notification: Notification) {
        guard let info = notification.userInfo, let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else {
                return
        }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillbeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }

    private func updateUI() {
        if let relation = rivalResponse?.relation {
            guard let autoChangePrice =  relation.auto else {
                autoChangePriceSwitch.isOn = false
                maxPriceRange.text = ""
                minPriceRange.text = ""
                priceDiff.text = ""
                
                return
            }
            
            if autoChangePrice {
               autoChangePriceSwitch.isOn = true
                guard let min = rivalResponse?.relation?.min, let max = rivalResponse?.relation?.max, let _priceDiff = rivalResponse?.relation?.price else {
                    return
                }
                
                maxPriceRange.text = String(describing: max)
                minPriceRange.text = String(describing: min)
                priceDiff.text = String(describing: _priceDiff)
            }
            else {
               autoChangePriceSwitch.isOn = false
            }

        }
    }
    @IBAction func save(_ sender: Any) {
        let rivalProductId = self.rivalResponse?.itemRival?.itemid
        let rivalShopId = self.rivalResponse?.itemRival?.shopid
        
        guard let min = minPriceRange.text, let max = maxPriceRange.text, let priceDiff = priceDiff.text else {
            print("this go to nil")
            return
        }
        
        print(max)
        print(min)
        RivalApiService.chooseRival(myProductId: (self.rivalResponse?.relation?.itemid)!,
                                    myShopId: (self.rivalResponse?.relation?.shopid)!,
                                    rivalProductId: rivalProductId!,
                                    rivalShopId: rivalShopId!,
                                    autoUpdate: true,
                                    priceDiff: Double(priceDiff),
                                    from: Double(min),
                                    to: Double(max)) { (result) in
            if result == .success {
                self.presentAlert(title: "Thông báo", message: "Bật thành công")
                
                NotificationCenter.default.post(name: .didSwitchAutoUpdate, object: nil, userInfo: nil)
            }
            
        }
    }
}



