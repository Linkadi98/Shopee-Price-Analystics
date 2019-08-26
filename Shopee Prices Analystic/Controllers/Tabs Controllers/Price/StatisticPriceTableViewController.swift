//
//  StatisticPriceTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/26/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class StatisticalPriceTableViewController: UITableViewController {
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            break
        }
        
        return nil
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    
    // MARK: - Calculate Price
    
    func calculatePriceSpaceFrom(productPrice: Int, firstPulp: Int, secondPulp: Int) -> (String, String) {
        return (Int(productPrice*firstPulp/100).convertPriceToVietnameseCurrency()!, Int(productPrice*secondPulp/100).convertPriceToVietnameseCurrency()!)
    }
    
}