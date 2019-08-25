//
//  CategoryTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/19/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import SkeletonView
import NotificationBannerSwift

class ProductsTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, SkeletonTableViewDataSource {
    
    // MARK: - Properties
    @IBOutlet weak var editingButton: UIButton! {
        didSet {
            editingButton.layer.cornerRadius = 8
            editingButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner]
        }
    }

    var currentShop: Shop?
    var listProducts: [Product]?
    var filterProducts: [Product]?
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.backgroundImage = UIImage()
        self.navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        setupSearchController(for: searchController, placeholder: "Nhập tên sản phẩm")
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl?.tintColor = UIColor.orange
        
        tableView.separatorColor = .none
        tableView.separatorStyle = .none

        if let currentShop = getObjectInUserDefaults(forKey: "currentShop") as? Shop {
            self.currentShop = currentShop
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        view.startSkeletonAnimation()

        guard listProducts != nil, let currentShop = getObjectInUserDefaults(forKey: "currentShop") as? Shop, self.currentShop == currentShop else {
            fetchDataFromServer()
            return
        }
    }

    override func viewDidAppear(_ animated: Bool) {

    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(searchController) {
            return filterProducts?.count ?? 10
        }
        return listProducts?.count ?? 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell

        guard listProducts != nil else {
            return cell
        }
        
        let product: Product

        if isFiltering(searchController) {
            product = filterProducts![indexPath.row]
        }
        else {
            product = listProducts![indexPath.row]
        }

        cell.productName.text = "\(product.name!)"
        cell.cosmos.rating = product.rating!
        cell.productPrice.text = product.convertPriceToVietnameseCurrency()
        cell.productCode.text = product.id!
        loadOnlineImage(from: URL(string: product.image!)!, to: cell.productImage)

        cell.hideSkeletonAnimation()

        if tableView.isEditing {
            showEditingPen(at: cell)
        }
        else {
            hideEditingPen(at: cell)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: tableView.rowHeight, duration: 0.3, delayFactor: 0.03)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product: Product
        
        if listProducts != nil {
            if isFiltering(searchController) {
                product = filterProducts![indexPath.row]
            }
            else {
                product = listProducts![indexPath.row]
            }
            
            if tableView.isEditing {
                presentChangePriceAlert(productIndex: indexPath.row)
                print("Cell is selected")
            }
            else {
                performSegue(withIdentifier: "ProductDetail", sender: product)
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let searchForRivals = UITableViewRowAction(style: .normal, title: "Tìm đối thủ", handler: { (action, indexPath) in
//            
//        })
//        
//        searchForRivals.
//    }
    
    
    // MARK: - Skeleton data source
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "productTableCell"
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }


    // MARK: - Search Actions
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!) { (searchText) in
            filterProducts = listProducts?.filter({(product: Product) -> Bool in
                return product.name!.lowercased().contains(searchText.lowercased()) || product.id!.lowercased().contains(searchText.lowercased())
            })
        }
    }
    
    // MARK: - Actions
    
    @IBAction func editingMode(_ sender: Any) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            
            changeTextOfEditingButton(text: "Sửa giá")
            
            for cell in tableView.visibleCells {
                let indexPath = tableView.indexPath(for: cell)!
                hideEditingPen(at: tableView.cellForRow(at: indexPath)!)
            }
        }
        else {
            tableView.setEditing(true, animated: true)
            changeTextOfEditingButton(text: "Xong")
            tableView.allowsSelection = true
            for cell in tableView.visibleCells {
                let indexPath: IndexPath = tableView.indexPath(for: cell)!
                showEditingPen(at: tableView.cellForRow(at: indexPath)!)
            }
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductDetail" && !tableView.isEditing {
            let vc = segue.destination as! ProductDetailTableViewController
            vc.product = (sender as! Product)
        }
    }
    
    // MARK: - Editing mode
    
    private func showEditingPen(at cell: UITableViewCell) {
        UIView.animate(withDuration: 0.3, animations: {
            let editingCell = cell as! ProductTableViewCell
            editingCell.editingPen.alpha = 1
        })
    }
    
    private func hideEditingPen(at cell: UITableViewCell) {
        UIView.animate(withDuration: 0.3, animations: {
            let editingCell = cell as! ProductTableViewCell
            editingCell.editingPen.alpha = 0
        })
    }
    
    private func presentChangePriceAlert(productIndex: Int) {
        let product = listProducts![productIndex]
        let alert = UIAlertController(title: "Sản phẩm \(product.name!)", message: "Nhập giá bạn muốn thay đổi", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textfield in
            textfield.borderStyle = .none
            textfield.text = String(product.price!)
        })
        
        let cancel = UIAlertAction(title: "Huỷ", style: .destructive, handler: nil)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            guard let newPrice = Int(alert.textFields![0].text!) else {
                self.presentAlert(message: "Xin mời nhập đúng giá")
                return
            }

            guard newPrice != product.price! else {
                self.presentAlert(title: "Thông báo", message: "Giá không thay đổi")
                return
            }

            UIApplication.shared.beginIgnoringInteractionEvents()

            let activityIndicator = self.initActivityIndicator()
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            // đối giá tại đây
            self.updatePrice(shopId: product.shopId!, productId: product.id!, newPrice: newPrice) { result in
                if result == "failed" {
                    self.presentAlert(title: "Lỗi kết nối", message: "Kiểm tra kết nối")
                } else if result == "wrong" {
                    self.presentAlert(title: "Lỗi không xác định", message: "Vui lòng thử lại sau")
                } else if result == "success" {
                    self.presentAlert(title: "Thông báo", message: "Sửa giá thành công")
                    self.listProducts![productIndex].price = newPrice
                    self.tableView.reloadRows(at: [IndexPath(row: productIndex, section: 0)], with: .automatic)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    activityIndicator.stopAnimating()
                    if activityIndicator.isAnimating == false {
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                }
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func changeTextOfEditingButton(text: String) {
        editingButton.setTitle(text, for: .normal)
    }
    
    // MARK: - Private loading data for this class
    
    private func fetchDataFromServer() {
        for row in 0...self.tableView.numberOfRows(inSection: 0) {
            self.tableView.cellForRow(at: IndexPath(row: row, section: 0))?.isHidden = false
        }

        view.hideSkeleton()
        view.showAnimatedSkeleton()
        
        tableView.allowsSelection = false
        
        putListProducts { [unowned self] (result, listProducts) in
            guard result != .failed else {
                self.tableView.reloadData()
                self.displayNoDataNotification(title: "Không có dữ liệu, kiểm tra lại kết nối", message: "Sản phẩm của bạn sẽ hiện tại đây")
                return
            }

            guard result != .error, let listProducts = listProducts else {
                self.tableView.reloadData()
                let banner = FloatingNotificationBanner(title: "Chưa kết nối đến cửa hàng nào",
                                                        subtitle: "Bấm vào đây để kết nối",
                                                        style: .warning)
                banner.onTap = {
                    self.tabBarController?.selectedIndex = 4
                }
                banner.show(queuePosition: .back,
                            bannerPosition: .top,
                            cornerRadius: 10)
                self.displayNoDataNotification(title: "Chưa kết nối cửa hàng nào", message: "Hãy kết nối cửa hàng ở mục Tài khoản")
                return
            }

            guard !listProducts.isEmpty else {
                self.tableView.reloadData()
                self.displayNoDataNotification(title: "Cửa hàng chưa có sản phẩm nào", message: "Xin mời quay lại Shopee để thêm sản phẩm")
                return
            }

            print("So san pham la: \(listProducts.count)")
            self.listProducts = listProducts
            self.tableView.reloadData()

            self.view.hideSkeleton()
            self.view.stopSkeletonAnimation()
            self.tableView.backgroundView = nil
            self.tableView.allowsSelection = true
        }
    }

    // MARK: - Refesh data
    @objc func refresh() {
        fetchDataFromServer()
        tableView.refreshControl?.endRefreshing()
    }
}

extension UIView {

    func centerInContainingWindow() {
        guard let window = self.window else { return }

        let windowCenter = CGPoint(x: window.frame.midX, y: window.frame.midY)
        self.center = self.superview!.convert(windowCenter, from: nil)
    }

}
