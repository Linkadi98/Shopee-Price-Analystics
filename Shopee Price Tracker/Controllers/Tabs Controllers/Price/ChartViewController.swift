//
//  ChartsViewController.swift
//  Shopee Prices Analystic
//
//  Created by Duy Truong on 8/28/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class ChartsViewController: UIViewController {

    var product: Product?
    var counts: [Int]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChart1" {
            if let columnChartViewController = segue.destination as? ColumnChartViewController {
                columnChartViewController.counts = counts!
                columnChartViewController.product = product!
            }
        } else if segue.identifier == "ShowChart2" {
            if let pieChartViewController = segue.destination as? PieChartViewController {
                pieChartViewController.counts = counts!
                pieChartViewController.product = product!
            }
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
