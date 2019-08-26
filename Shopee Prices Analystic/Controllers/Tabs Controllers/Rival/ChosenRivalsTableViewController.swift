//
//  ChosenRivalsTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/22/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class ChosenRivalsTableViewController: UITableViewController {
    
    // MARK: - Properties
    var product: Product?
    var chosenRivals: [(Product, Shop, Observation)]?
    var currentShop: Shop?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = .none
        tableView.separatorStyle = .none

        if let currentShop = getObjectInUserDefaults(forKey: "currentShop") as? Shop {
            self.currentShop = currentShop
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        view.startSkeletonAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        guard let currentShop = getObjectInUserDefaults(forKey: "currentShop") as? Shop, let _ = product else {
            self.presentAlert(title: "Lỗi không xác định", message: "Vui lòng thử lại sau")
            return
        }

        guard chosenRivals != nil else {
            fetchDataFromServer()
            return
        }

        if self.currentShop == currentShop {
            //
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chosenRivals?.count ?? 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChosenRivalCell", for: indexPath) as! ChosenRivalCell

        guard let chosenRivals = chosenRivals else {
            return cell
        }

        let rival = chosenRivals[indexPath.row].0
        let rivalShop = chosenRivals[indexPath.row].1
        let observation = chosenRivals[indexPath.row].2

        cell.productName.text = rival.name
        cell.productPrice.text = "\(rival.price.convertPriceToVietnameseCurrency()!)"
        cell.rivalShopRating.text = String("\(rivalShop.rating)".prefix(3))
        cell.rivalShopRating.rating = rivalShop.rating
        cell.follower.text = "\(rivalShop.followersCount)"
        loadOnlineImage(from: URL(string: rival.image)!, to: cell.productImage)
        cell.rivalName.text = rivalShop.shopName
        switch observation.autoUpdate {
        case true:
            cell.setAutoStatusOn()
        default:
            cell.setAutoStatusOff()
        }

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let chosenRivals = chosenRivals else {
            presentAlert(title: "Lỗi không xác định", message: "Vui lòng thử lại sau")
            return
        }
        print("xxx: \(chosenRivals)")
        performSegue(withIdentifier: "rivalInfoSegue", sender: chosenRivals[indexPath.row])
    }
 

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rivalInfoSegue" {
            if let chosenRival = sender as? (Product, Shop, Observation) {
                print("zzz: \(chosenRival)")
                if let containerRivalInfoViewController = segue.destination as? ContainerRivalInfoViewController {
                    containerRivalInfoViewController.chosenRival = chosenRival
                    containerRivalInfoViewController.product = product!
                }
            }

        }
    }
    
    private func fetchDataFromServer() {
        for row in 0...self.tableView.numberOfRows(inSection: 0) {
            self.tableView.cellForRow(at: IndexPath(row: row, section: 0))?.isHidden = false
        }

        view.hideSkeleton()
        view.showAnimatedSkeleton()

        tableView.allowsSelection = false

        getChosenRivals(shopId: product!.shopId, productId: product!.id) { (result, chosenRivals) in
            guard result != .failed, let chosenRivals = chosenRivals else {
                self.tableView.reloadData()
                self.displayNoDataNotification(title: "Không có dữ liệu, kiểm tra lại kết nối", message: "Đối thủ của bạn sẽ hiện tại đây")
                return
            }

            guard !chosenRivals.isEmpty else {
                self.tableView.reloadData()
                self.displayNoDataNotification(title: "Chưa theo dõi đối thủ nào", message: "Xin mời quay lại để chọn đối thủ")
                return
            }

            self.chosenRivals = chosenRivals
            self.tableView.reloadData()

            self.view.hideSkeleton()
            self.view.stopSkeletonAnimation()
            self.tableView.backgroundView = nil
            self.tableView.allowsSelection = true
        }
    }
}
