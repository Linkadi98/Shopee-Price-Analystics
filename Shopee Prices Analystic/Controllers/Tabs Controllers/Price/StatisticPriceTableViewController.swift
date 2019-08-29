//
//  StatisticPriceTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/26/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class StatisticalPriceTableViewController: UITableViewController {

    var product: Product?
    var counts: [Int]?
    
    // MARK: - Properties
    @IBOutlet weak var amount1: UILabel!
    @IBOutlet weak var percent1: UILabel!
    
    @IBOutlet weak var amount2: UILabel!
    @IBOutlet weak var percent2: UILabel!
    
    @IBOutlet weak var amount3: UILabel!
    @IBOutlet weak var percent3: UILabel!
    
    @IBOutlet weak var amount4: UILabel!
    @IBOutlet weak var percent4: UILabel!
    
    @IBOutlet weak var amount5: UILabel!
    @IBOutlet weak var percent5: UILabel!
    
    @IBOutlet weak var amount6: UILabel!
    @IBOutlet weak var percent6: UILabel!
    
    @IBOutlet weak var amount7: UILabel!
    @IBOutlet weak var percent7: UILabel!
    
    @IBOutlet weak var amount8: UILabel!
    @IBOutlet weak var percent8: UILabel!
    
    @IBOutlet weak var amount9: UILabel!
    @IBOutlet weak var percent9: UILabel!
    
    @IBOutlet weak var amount10: UILabel!
    @IBOutlet weak var percent10: UILabel!
    
    
    @IBOutlet weak var totalRivals: UILabel!
    @IBOutlet weak var numberOfLowerPrice: UILabel!
    @IBOutlet weak var numberOfEqualPrice: UILabel!
    @IBOutlet weak var numberOfHigherPrice: UILabel!
    @IBOutlet weak var averagePrice: UILabel!
    @IBOutlet weak var modPrice: UILabel!
    
    @IBOutlet weak var showChartsButton: UIButton!

    
    var hasData = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(didChosenProductToObserve(_:)), name: NSNotification.Name(rawValue: "didChosenProductToObserve"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidChangeShop(_:)), name: .didChangeCurrentShop, object: nil)
        if hasData {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        else {
            presentAlert(title: "Không có dữ liệu", message: "Bạn chưa chọn sản phẩm nào để theo dõi")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String = "Khoảng giá từ "
        var tuple: (String, String)
        switch section {
        case 0:
            tuple = calculatePriceSpaceFrom(productPrice: 100000, firstPulp: 50, secondPulp: 60)
            title = title + tuple.0 + " đến " + tuple.1
            return title
        default:
            return "Thống kê giá sản phẩm"
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !hasData {
            return 0
        }
        return 50
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if hasData {
            return 60
        }
        return 0
    }
    
    
    // MARK: - Calculate Price
    
    func calculatePriceSpaceFrom(productPrice: Int, firstPulp: Int, secondPulp: Int) -> (String, String) {
        return (Int(productPrice*firstPulp/100).convertPriceToVietnameseCurrency()!, Int(productPrice*secondPulp/100).convertPriceToVietnameseCurrency()!)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StatisticPriceTVCToChartsVC" {
            if let chartsViewController = segue.destination as? ChartsViewController {
                chartsViewController.product = product!
                chartsViewController.counts = counts!
            }
        }
    }

    @IBAction func chooseProductsToObserve(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let productsTableViewController = sb.instantiateViewController(withIdentifier: "ProductsTVC") as! ProductsTableViewController
        navigationController?.pushViewController(productsTableViewController, animated: true)
        productsTableViewController.isChosenToObservePrice = true
    }

    @IBAction func showCharts(_ sender: Any) {
        guard let _ = counts else {
            presentAlert(message: "Chưa chọn sản phẩm")
            return
        }

//        NotificationCenter.default.post(name: Notification.Name.didReceivedStatistics, object: nil, userInfo: ["counts": [counts]])
        performSegue(withIdentifier: "StatisticPriceTVCToChartsVC", sender: nil)
    }

    @objc func didChosenProductToObserve(_ notification: Notification) {
        if let product = notification.userInfo?["product"] as? Product {
            getStatistics(product: product) { (result, counts) in
                if result == .success, let counts = counts {
                    self.product = product
                    self.counts = counts
                    self.amount1.text = "\(counts[0])"
                }
            }
        }
    }
    
    @objc func onDidChangeShop(_ notification: Notification) {
        navigationController?.popToRootViewController(animated: false)
        hasData = false
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            print("Changed shop")
        }
    }
}
