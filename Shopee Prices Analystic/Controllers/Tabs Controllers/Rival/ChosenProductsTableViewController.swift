//
//  ChosenProductsTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/14/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import SkeletonView

class ChosenProductsTableViewController: UITableViewController, ChosenProductRivalCellDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var unFollowProduct: UIButton!
    var isPressButton = false
    
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

        // Đăng ký nhận thông báo chuyển sang shop mới
        NotificationCenter.default.addObserver(self, selector: #selector(didSwitchAutoUpdate), name: .didSwitchAutoUpdate, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(_:)), name: .didChangeCurrentShop, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onChooseRival(_:)), name: .didChooseRival, object: nil)

        guard chosenProducts != nil else {
            fetchDataFromServer()
            return
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
        if product.2 == false {
            cell.autoChangePriceStatus.backgroundColor = .red
            cell.autoChangePriceStatus.text = "Tắt"
        }

        cell.delegate = self
        cell.row = indexPath.row
        cell.section = indexPath.section
        
        if isPressButton {
            move(cell.contentView.subviews[1], to: .right)
            UIView.fadeIn(view: cell.deleteButton, duration: 0.45)
        }
        else {
            move(cell.contentView.subviews[1], to: .left)
            UIView.fadeOut(view: cell.deleteButton, duration: 0.45)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: tableView.rowHeight, duration: 0.3, delayFactor: 0.03)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // thay đổi đối tượng truyền sang view khác bằng sender khác
        guard let chosenProducts = chosenProducts else {
            presentAlert(title: "Lỗi không xác định", message: "Vui lòng thử lại sau")
            return
        }
        performSegue(withIdentifier: "chosenRivalSegue", sender: chosenProducts[indexPath.row].0)
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chosenRivalSegue" {
            guard let chosenProduct = sender as? Product else {
                presentAlert(title: "Lỗi không xác định", message: "Vui lòng thử lại sau")
                return
            }
            if let chosenRivalsTableViewController = segue.destination as? ChosenRivalsTableViewController {
                chosenRivalsTableViewController.product = chosenProduct
            }
        }
    }
    
    // MARK: - Delete followed Rival
    
    
    @IBAction func deleteFollowedRival(_ sender: Any) {
        if !isPressButton {
            for cell in tableView.visibleCells {
                move(cell.contentView.subviews[1], to: .right)
                if let cell = cell as? ChosenProductTableViewCell {
                    UIView.fadeIn(view: cell.deleteButton, duration: 0.45)
                }
            }
            unFollowProduct.setTitle("Xong", for: .normal)
            isPressButton = true
        }
        else {
            for cell in tableView.visibleCells {
                move(cell.contentView.subviews[1], to: .left)
                if let cell = cell as? ChosenProductTableViewCell {
                    UIView.fadeOut(view: cell.deleteButton, duration: 0.4)
                }
            }
            
            unFollowProduct.setTitle("Huỷ theo dõi", for: .normal)
            isPressButton = false
        }
    }
    
    
    func move(_ view: UIView, to direction: Direction) {
        switch direction {
        case .left:
            UIView.animate(withDuration: 0.3, animations: {
                view.transform = .identity
            })
        default:
            UIView.animate(withDuration: 0.3, animations: {
                view.transform = CGAffineTransform(translationX: 40, y: 0)
            })
        }
    }
    
    
    func deleteRow(at row: Int, in section: Int) {
        let deletedRow = chosenProducts![row].0.id
        let indexPath = IndexPath(row: row, section: section)
        print("indexPath: \(row)")
        chosenProducts?.remove(at: indexPath.row)
        
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [indexPath], with: .right)
        }, completion: { _ in
            self.updateIndexPath()
        })

        presentAlert(title: "Xoá tại \(deletedRow)", message: "")
//        deleteChosenProductFromServer(row: row)
        // call api xoá tại đây
    }
    
    func updateIndexPath() {
        var count = 0
//        for cell in tableView. {
//            guard let cell = cell as? ChosenProductTableViewCell else {
//                return
//            }
//            cell.row = count
//            count += 1
//        }
    }
    
    func deleteChosenProductFromServer(row: Int) {
        deleteRivals(productId: self.chosenProducts![row].0.id) { (result) in
            if result == .success {
                self.presentAlert(title: "Thông báo", message: "Xoá thành công")
                self.fetchDataFromServer()
            }
        }
    }
    
    // MARK: - Fetching data from server

    private func fetchDataFromServer() {
        if let currentShop = getObjectInUserDefaults(forKey: "currentShop") as? Shop {
            self.currentShop = currentShop
        }
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
            DispatchQueue.main.async {

                self.tableView.reloadData()
            }

            self.view.hideSkeleton()
            self.view.stopSkeletonAnimation()
            self.tableView.backgroundView = nil
            self.tableView.allowsSelection = true
        }
    }
    
    // MARK: - Notification
    
    @objc func reloadData(_ notification: Notification) {
        fetchDataFromServer()
        navigationController?.popToRootViewController(animated: false)
        tableView.reloadData()
        print("did receive data")
    }
    
    @objc func onChooseRival(_ notification: Notification) {
        fetchDataFromServer()
        
        print("load lai tab san pham da chon")
    }

    @objc func didSwitchAutoUpdate() {
        fetchDataFromServer()
        tableView.reloadData()

        print("fetchDataFromServer()")
    }
}
