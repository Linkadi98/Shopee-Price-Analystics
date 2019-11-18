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
    var percents: [Int]?
    
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
    var delegate: PriceObserveDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        product = delegate?.getProduct()
        if product == nil {
            return
        }
        else {
            reloadDataWith(product: self.product!)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(didChooseProductToObserve(_:)), name: NSNotification.Name(rawValue: "didChooseProductToObserve"), object: nil)

        print("Chosen Product will appear")
        if let _ = product {
            hasData = true
        }

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
        if let product  = product {
            guard section < 10 else {
                return "Thống kê sản phẩm"
            }

            let price = product.price
            var tuple: (String, String)

            tuple = calculatePriceSpaceFrom(productPrice: price!, firstPulp: section * 10 + 50, secondPulp: section * 10 + 60)
            title = title + tuple.0 + " đến " + tuple.1
        }

        return title
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
        tabBarController?.selectedIndex = 1
        let navigationVC = tabBarController?.selectedViewController as! UINavigationController
        navigationVC.popToRootViewController(animated: false)
    }

    @IBAction func showCharts(_ sender: Any) {
        guard let _ = counts else {
            presentAlert(message: "Chưa chọn sản phẩm")
            return
        }

//        NotificationCenter.default.post(name: Notification.Name.didReceivedStatistics, object: nil, userInfo: ["counts": [counts]])
        performSegue(withIdentifier: "StatisticPriceTVCToChartsVC", sender: nil)
    }

    @objc func didChooseProductToObserve(_ notification: Notification) {
        if let product = notification.userInfo?["product"] as? Product {
            reloadDataWith(product: product)
        }
    }
    
    private func reloadDataWith(product: Product) {
        print("123 \(product)")
        self.product = product
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        print("did Choose To observe")
        let alert = UIAlertController(title: "Đang tải dữ liệu...", message: nil, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        getStatistics(product: product) { [unowned self] (result, counts, averagePrice) in
                if result == .success, let counts = counts, let averagePrice = averagePrice {
                self.counts = counts
                
                var percents: [Int] = []
                let sum = counts.reduce(0, +)
                for count in counts {
                    percents.append(count * 100 / sum)
                }
                self.percents = percents
                self.counts = counts
                
                self.updateAmountLabels(counts: counts)
                self.updatePercentLabels(percents: percents)
                self.updateSummary(product: self.product!, counts: counts, averagePrice: averagePrice)
            }
            
            alert.dismiss(animated: true, completion: nil)
        }
    }

    private func updateAmountLabels(counts: [Int]) {
        tableView.beginUpdates()
        amount1.text = "\(counts[0])"
        amount2.text = "\(counts[1])"
        amount3.text = "\(counts[2])"
        amount4.text = "\(counts[3])"
        amount5.text = "\(counts[4])"
        amount6.text = "\(counts[5])"
        amount7.text = "\(counts[6])"
        amount8.text = "\(counts[7])"
        amount9.text = "\(counts[8])"
        amount10.text = "\(counts[9])"
        tableView.endUpdates()
    }

    private func updatePercentLabels(percents: [Int]) {
        tableView.beginUpdates()
        percent1.text = "\(percents[0])%"
        percent2.text = "\(percents[1])%"
        percent3.text = "\(percents[2])%"
        percent4.text = "\(percents[3])%"
        percent5.text = "\(percents[4])%"
        percent6.text = "\(percents[5])%"
        percent7.text = "\(percents[6])%"
        percent8.text = "\(percents[7])%"
        percent9.text = "\(percents[8])%"
        percent10.text = "\(percents[9])%"
        tableView.endUpdates()
    }

    private func updateSummary(product: Product, counts: [Int], averagePrice: Int) {
        let sum = counts.reduce(0, +)
        var lowerSum = 0
        var equalSum = 0
        var higherSum = 0

        for index in 0...9 {
            if index < 4 {
                lowerSum += counts[index]
            } else if index < 6 {
                equalSum += counts[index]
            } else {
                higherSum += counts[index]
            }
        }


        totalRivals.text = "\(counts.count)"
        numberOfLowerPrice.text = "\(Int(lowerSum * 100 / sum))%"
        numberOfEqualPrice.text = "\(Int(equalSum * 100 / sum))%"
        numberOfHigherPrice.text = "\(Int(higherSum * 100 / sum))%"

        self.averagePrice.text = "\(averagePrice.convertPriceToVietnameseCurrency()!)"
        modPrice.text = "\(counts.firstIndex(of: counts.max()!)! * 10 + 50)%-\(counts.firstIndex(of: counts.max()!)! * 10 + 60)%"
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
