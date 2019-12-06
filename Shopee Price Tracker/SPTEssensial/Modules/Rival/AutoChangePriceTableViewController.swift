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
//    var product: Product?
//    var rivalProduct: Product?
    var rivalResponse: RivalsResponse? // current
    var chosenRivals: [RivalsResponse]?

    @IBOutlet weak var shopChangePicker: UIPickerView!
    @IBOutlet weak var autoChangePriceSwitch: UISwitch!
    @IBOutlet weak var minPriceRange: UITextField!
    @IBOutlet weak var maxPriceRange: UITextField!
    @IBOutlet weak var priceDiff: UITextField!
    

//    var rivalProducts: [Product]?

    var pickerVisible = true
    
    var delegate: PickerNameDelegate?

    // Đưa tên các đối thủ được chọn vào trong pickerData
    var pickerData = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        shopChangePicker.delegate = self
        shopChangePicker.dataSource = self
        
        maxPriceRange.delegate = self
        minPriceRange.delegate = self
        priceDiff.delegate = self

        autoChangePriceSwitch.isOn = false
        
        hideKeyboardWhenTappedAround()
        registerKeyboardForNotification()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func viewWillAppear(_ animated: Bool) {
        pickerData.append(contentsOf: (delegate?.addNameToPicker())!)
        updateUI()
    }

    @IBAction func switchAutoChangePrice(_ sender: Any) {
        tableView.beginUpdates()
        tableView.endUpdates()

        // Turn off auto updating
        if rivalResponse?.rival?.auto == true {
            if !autoChangePriceSwitch.isOn {
                let alert = UIAlertController(title: "Bạn muốn tắt chỉnh giá tự động?", message: nil, preferredStyle: .alert)
                let cancelButton = UIAlertAction(title: "Huỷ", style: .destructive) { _ in
                    self.autoChangePriceSwitch.isOn = true
                }
                let okButton = UIAlertAction(title: "OK", style: .default) { (_) in
                    let activityIndicator = self.startLoading()

                    RivalApiService.chooseRival(myProductId: (self.rivalResponse?.itemRival?.itemid)!, myShopId: (self.rivalResponse?.rival?.shopid)!, rivalProductId: (self.rivalResponse?.itemRival?.itemid)!, rivalShopId: (self.rivalResponse?.itemRival?.shopid)!, autoUpdate: false, priceDiff: 0, from: 0, to: 0, completion: { (result) in
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
//        switch textField.tag {
//        case 0:
//            print("min")
//        case 1:
//            print("max")
//        case 2:
//            print("diff")
//        default:
//            break
//        }
//        if minPriceRange.isFirstResponder {
//            maxPriceRange.becomeFirstResponder()
//            return false
//        }
//        else {
//            maxPriceRange.resignFirstResponder()
//            return true
//        }
        let (result, message) = checkTextFields()
        guard result else {
            self.presentAlert(message: message)
            return true
        }

        let alert = UIAlertController(title: "Bạn muốn bật chỉnh giá tự động?", message: nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Huỷ", style: .destructive, handler: nil)
        let okButton = UIAlertAction(title: "OK", style: .default) { (_) in
            let activityIndicator = self.startLoading()

            let selectedRowOfPicker = self.shopChangePicker.selectedRow(inComponent: 0)
            let rivalProductId = self.chosenRivals![selectedRowOfPicker].itemRival?.itemid
            let rivalShopId = self.chosenRivals![selectedRowOfPicker].itemRival?.shopid
            RivalApiService.chooseRival(myProductId: (self.rivalResponse?.itemRival?.itemid)!, myShopId: (self.rivalResponse?.rival?.shopid)!, rivalProductId: rivalProductId!, rivalShopId: rivalShopId!, autoUpdate: true, priceDiff: Int(self.priceDiff.text!)!, from: Int(self.minPriceRange.text!)!, to: Int(self.maxPriceRange.text!)!) { (result) in
                if result == .success {
                    self.presentAlert(title: "Thông báo", message: "Bật thành công")

                    NotificationCenter.default.post(name: .didSwitchAutoUpdate, object: nil, userInfo: nil)
                }

                self.endLoading(activityIndicator)
            }
        }

        alert.addAction(cancelButton)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)

        textField.resignFirstResponder()
        
        return true
    }

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
        if let observation = rivalResponse?.rival {
            guard observation.auto != nil else {
                autoChangePriceSwitch.isOn = false
                maxPriceRange.text = ""
                minPriceRange.text = ""
                priceDiff.text = ""
                
                return
            }

            autoChangePriceSwitch.isOn = true
            maxPriceRange.text = String(describing: rivalResponse?.rival?.max)
            minPriceRange.text = String(describing: rivalResponse?.rival?.min)
            priceDiff.text = String(describing: rivalResponse?.rival?.price)
        }
    }
}



