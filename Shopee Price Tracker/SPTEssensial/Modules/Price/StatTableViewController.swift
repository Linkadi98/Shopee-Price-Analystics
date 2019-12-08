//
//  StatTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/8/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class StatTableViewController: UITableViewController {

    let STAT_CELL = "SPTStatCell"
    let CHART_CELL = "SPTChartCell"
    
    var vm: StatTableViewViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
        print(vm?.product)
    }

    override func viewDidAppear(_ animated: Bool) {
        fetchDataFromServer()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.row == 0 {
            tableView.register(UINib(nibName: STAT_CELL, bundle: nil), forCellReuseIdentifier: STAT_CELL)
            let cell = tableView.dequeueReusableCell(withIdentifier: STAT_CELL) as! SPTStatCell
            cell.mediumPrice.text = vm?.data?.value.1.convertPriceToVietnameseCurrency()
            return cell
            
        } else {
            
            if indexPath.row == 1 {
                tableView.register(UINib(nibName: CHART_CELL, bundle: nil), forCellReuseIdentifier: CHART_CELL)
                let cell = tableView.dequeueReusableCell(withIdentifier: CHART_CELL) as! SPTChartCell
                cell.drawChart(type: .column, with: vm?.product, and: vm?.data?.value.0)
                return cell
            }
            else {
                tableView.register(UINib(nibName: CHART_CELL, bundle: nil), forCellReuseIdentifier: CHART_CELL)
                let cell = tableView.dequeueReusableCell(withIdentifier: CHART_CELL) as! SPTChartCell
                cell.drawChart(type: .pie, with: vm?.product, and: vm?.data?.value.0)
                return cell
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 60.0
        }
        else {
            return 450.0
        }
    }
    
    func configViewModel() {
        vm?.data?.bind { (counts, mediumPrice) in
            self.tableView.reloadData()
        }
    }
    
    func fetchDataFromServer() {
        vm?.fetchDataFromServer { result, counts, mediumPrice in
            guard result != .failed, let counts = counts, let mediumPrice = mediumPrice else {
                return
            }
            
            self.vm?.data?.value = (counts, mediumPrice)
        }
    }

}
