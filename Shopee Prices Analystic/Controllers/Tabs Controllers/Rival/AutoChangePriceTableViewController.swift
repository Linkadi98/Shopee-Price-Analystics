//
//  AutoChangePriceTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/14/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class AutoChangePriceTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var shopChangePicker: UIPickerView!
    @IBOutlet weak var autoChangePriceSwitch: UISwitch!
    @IBOutlet weak var minPriceRange: UITextField!
    @IBOutlet weak var maxPriceRange: UITextField!
    
    var pickerVisible = true
    // Đưa tên các đối thủ được chọn vào trong pickerData
    var pickerData = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        shopChangePicker.delegate = self
        shopChangePicker.dataSource = self
        
        maxPriceRange.delegate = self
        minPriceRange.delegate = self

        // Cần có trạng thái tự động sửa giá isAutoUpdate trong cơ sở dữ liệu để biết được sản phẩm nào
        // sẽ tự động sửa giá hoặc k tự động sửa giá
        
        // test only, autoChangePriceSwitch is always false for the first time
        autoChangePriceSwitch.isOn = false
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(onAppearChosenProduct(_:)), name: .didAppearChosenProduct, object: nil)
        print("view did load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    @IBAction func switchAutoChangePrice(_ sender: Any) {
        tableView.beginUpdates()
        tableView.endUpdates()
        
        if !autoChangePriceSwitch.isOn {
            maxPriceRange.text = ""
            minPriceRange.text = ""
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            pickerVisible = !pickerVisible
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
            pickerVisible = false
            return 0.0
        }
        
        if indexPath.row == 2 {
            if !pickerVisible {
                return 0.0
            }
            return 120.0
        }
        return 60.0
    }
    
    // MARK: - PickerView data source and delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // chọn tên shop tại đây
        
        // picker only chooses item when user hasn't scrolled picker anymore, try to run an see results
        print("\(pickerData[row])")
    }
    
    // MARK: - Textfield delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if minPriceRange.isFirstResponder {
            maxPriceRange.becomeFirstResponder()
            return false
        }
        else {
            maxPriceRange.resignFirstResponder()
            return true
        }
    }
    
    // MARK: - Helper for picker view
    
    @objc func onAppearChosenProduct(_ notification: Notification) {
        print("on appear")
        if let data = notification.userInfo as? [String: [Shop]] {
            
            let shops = data["Shop"]!
            for shop in shops {
                pickerData.append(shop.shopName)
            }
        }
        print("picker")
    }
    
}



