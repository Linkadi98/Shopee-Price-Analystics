//
//  ChosenRivalsTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/22/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class ChosenRivalsTableViewController: UITableViewController, ChosenRivalDelegate {
    
    // MARK: - Properties
    var product: Product?
    var chosenRivals: [(Product, Shop, Observation)]?
    var currentShop: Shop?
    
    var data: [String: Any]?

    @IBOutlet weak var deleteButton: UIButton!
    var isPressButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = .none
        tableView.separatorStyle = .none
        
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl?.tintColor = .orange

        if let currentShop = getObjectInUserDefaults(forKey: "currentShop") as? Shop {
            self.currentShop = currentShop
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(didSwitchAutoUpdate), name: .didSwitchAutoUpdate, object: nil)
        

//        view.startSkeletonAnimation()
        
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

        DispatchQueue.main.async {
            let rival = chosenRivals[indexPath.row].0
            let rivalShop = chosenRivals[indexPath.row].1
            let observation = chosenRivals[indexPath.row].2

            cell.productName.text = rival.name
            cell.productPrice.text = "\(rival.price!.convertPriceToVietnameseCurrency()!)"
            cell.rivalShopRating.text = String("\(rivalShop.rating)".prefix(3))
            cell.rivalShopRating.rating = rivalShop.rating
            cell.follower.text = "\(rivalShop.followersCount)"
            self.loadOnlineImage(from: URL(string: rival.image!)!, to: cell.productImage)
            cell.rivalName.text = rivalShop.shopName
            switch observation.autoUpdate {
            case true:
                cell.setAutoStatusOn()
            default:
                cell.setAutoStatusOff()
            }
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

//        cell.hideSkeletonAnimation()
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let chosenRivals = chosenRivals else {
            presentAlert(title: "Lỗi không xác định", message: "Vui lòng thử lại sau")
            return
        }

        let notificationName = NSNotification.Name(rawValue: "didGetRivalInfo")
        var rivalProducts: [Product] = []
        for chosenRival in chosenRivals {
            rivalProducts.append(chosenRival.0)
        }
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["rivalProducts": rivalProducts])

        performSegue(withIdentifier: "rivalInfoSegue", sender: chosenRivals[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 188.0
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
                    containerRivalInfoViewController.chosenRivals = chosenRivals
                }
            }

        }
    }
    
    // MARK: - Delete cell
    
    @IBAction func deleteCell(_ sender: Any) {
        if !isPressButton {
            for cell in tableView.visibleCells {
                move(cell.contentView.subviews[1], to: .right)
                if let cell = cell as? ChosenRivalCell {
                    UIView.fadeIn(view: cell.deleteButton, duration: 0.45)
                }
            }
            deleteButton.setTitle("Xong", for: .normal)
            isPressButton = true
        }
        else {
            for cell in tableView.visibleCells {
                move(cell.contentView.subviews[1], to: .left)
                if let cell = cell as? ChosenRivalCell {
                    UIView.fadeOut(view: cell.deleteButton, duration: 0.4)
                }
            }
            
            deleteButton.setTitle("Huỷ chọn", for: .normal)
            isPressButton = false
        }
    }
    
    
    func deleteRow(at row: Int, in section: Int) {
        let deletedId = (chosenRivals![row].0.id, chosenRivals![row].0.shopId)
        let alert = UIAlertController(title: "Xoá sản phẩm của \(chosenRivals![row].1.shopName)?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Huỷ", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in

            self.deleteRival(myProductId: self.product!.id!, myShopId: self.product!.shopId!, rivalProductId: deletedId.0!, rivalShopId: deletedId.1!, completion: { (result) in
                if result == .success {
                    self.presentAlert(title: "Thông báo", message: "Xoá thành công")
                    let indexPath = IndexPath(row: row, section: section)
                    self.chosenRivals?.remove(at: indexPath.row)

                    self.tableView.performBatchUpdates({
                        self.tableView.deleteRows(at: [indexPath], with: .right)
                    }, completion: { _ in
                        self.updateIndexPath(from: indexPath)
                    })

                    NotificationCenter.default.post(name: .didDeleteARival, object: nil, userInfo: nil)
                }
            })
        })

        present(alert, animated: true, completion: nil)
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
    
    func updateIndexPath(from indexPath: IndexPath) {
        var row = indexPath.row
        for cell in tableView.visibleCells {
            guard let cell = cell as? ChosenProductTableViewCell else {
                return
            }
            
            if cell.row < row + 1 {
                continue
            }
            cell.row = row
            row += 1
        }
    }
    
    func deleteChosenProductFromServer() {
        
    }
    
    
    private func fetchDataFromServer() {
        for row in 0...self.tableView.numberOfRows(inSection: 0) {
            self.tableView.cellForRow(at: IndexPath(row: row, section: 0))?.isHidden = false
        }

//        view.hideSkeleton()
//        view.showAnimatedSkeleton()

        tableView.allowsSelection = false

        getChosenRivals(shopId: product!.shopId!, productId: product!.id!) { (result, chosenRivals) in
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

            
            DispatchQueue.main.async {
                self.chosenRivals = chosenRivals
                self.tableView.reloadData()
            }
            
//            self.view.hideSkeleton()
//            self.view.stopSkeletonAnimation()
            self.tableView.backgroundView = nil
            self.tableView.allowsSelection = true
            
        }
    }
    
    // MARK: - Refresh
    
    @objc func refresh() {
        fetchDataFromServer()
        tableView.refreshControl?.endRefreshing()
    }

    @objc func didSwitchAutoUpdate() {
        fetchDataFromServer()
    }
    
}
