//
//  ChosenProductsTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/14/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import SkeletonView

class ChosenProductsTableViewController: UITableViewController {
    
    // MARK: - Properties
    var chosenProducts: [(Product, Int, Bool)]?
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

        guard let currentShop = getObjectInUserDefaults(forKey: "currentShop") as? Shop else {
            self.presentAlert(title: "Lỗi không xác định", message: "Vui lòng thử lại sau")
            return
        }

        guard chosenProducts != nil else {
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
        return chosenProducts?.count ?? 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chosenProductCell", for: indexPath) as! ChosenProductTableViewCell
        guard let chosenProducts = chosenProducts else {
            return cell
        }

        let product = chosenProducts[indexPath.row]

        cell.productId.text! = "Mã: \(product.0.id)"
        loadOnlineImage(from: URL(string: product.0.image)!, to: cell.productImage)
        cell.numberOfRival.text = "\(product.1)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: tableView.rowHeight, duration: 0.3, delayFactor: 0.03)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // thay đổi đối tượng truyền sang view khác bằng sender khác
        performSegue(withIdentifier: "chosenRivalSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chosenRivalSegue" {
        }
    }

    private func fetchDataFromServer() {
        for row in 0...self.tableView.numberOfRows(inSection: 0) {
            self.tableView.cellForRow(at: IndexPath(row: row, section: 0))?.isHidden = false
        }

        view.hideSkeleton()
        view.showAnimatedSkeleton()

        tableView.allowsSelection = false
        
        getChosenProducts(shopId: self.currentShop!.shopId) { [unowned self] (result, chosenProducts) in
            guard result != .failed, let chosenProducts = chosenProducts else {
                self.tableView.reloadData()
                self.displayNoDataNotification(title: "Không có dữ liệu, kiểm tra lại kết nối", message: "Sản phẩm của bạn sẽ hiện tại đây")
                return
            }

            guard !chosenProducts.isEmpty else {
                self.tableView.reloadData()
                self.displayNoDataNotification(title: "Chưa chọn sản phẩm nào", message: "Xin mời quay lại để chọn sản phẩm")
                return
            }

            print("So san pham da chon la: \(chosenProducts.count)")
            self.chosenProducts = chosenProducts
            self.tableView.reloadData()

            self.view.hideSkeleton()
            self.view.stopSkeletonAnimation()
            self.tableView.backgroundView = nil
            self.tableView.allowsSelection = true
        }
    }
}
