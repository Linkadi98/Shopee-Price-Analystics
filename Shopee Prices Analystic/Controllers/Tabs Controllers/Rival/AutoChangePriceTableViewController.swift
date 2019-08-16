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
        
        pickerData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
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
        
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    // this will be call for the first time, can be place in viewDidLoad for 1 time loading
    private func addNewRivalToPickerView() {
        
    }
    
    // this will be placed in viewWillLoad every time view has appeared
    private func reloadRivalsInPickerAfterChoosingOthers() {
        
    }
    
    
}



