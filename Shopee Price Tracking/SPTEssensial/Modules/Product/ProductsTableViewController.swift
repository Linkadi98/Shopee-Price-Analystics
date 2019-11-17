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
//    @IBOutlet weak var editingButton: UIButton! {
//        didSet {
//            editingButton.layer.cornerRadius = 8
//            editingButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner]
//        }
//    }

    var currentShop: Shop?
    var listProducts: [Product]?
    var filterProducts: [Product]?
    var searchController: UISearchController!
    
    var hasData = false
    var isChosenToObservePrice = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("product did load 677")
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.backgroundImage = UIImage()
        self.navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        setupSearchController(for: searchController, placeholder: "Nhập tên sản phẩm")
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl?.tintColor = UIColor.orange
        
        tableView.separatorColor = .none
        tableView.separatorStyle = .none

//        if isChosenToObservePrice {
//            editingButton.setTitle("Quay lại", for: .normal)
//        }


        guard let currentShop = getObjectInUserDefaults(forKey: "currentShop") as? Shop else {
            return
        }

        self.currentShop = currentShop
        
        // Notification
        NotificationCenter.default.addObserver(self, selector: #selector(reloadProduct(_:)), name: .didChangeCurrentShop, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        view.startSkeletonAnimation()

        guard listProducts != nil else {
            fetchDataFromServer()
            return
        }
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

        DispatchQueue.main.async {
            cell.productName.text = "\(product.name)"
            cell.cosmos.rating = product.rating
            cell.productPrice.text = product.price.convertPriceToVietnameseCurrency()
            cell.productCode.text = product.id
        }
        loadOnlineImage(from: URL(string: product.image)!, to: cell.productImage)

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
        tableView.scrollsToTop = true
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

            if isChosenToObservePrice {
//                let statisticalPriceTableViewController = navigationController?.viewControllers[0] as! StatisticalPriceTableViewController
//                statisticalPriceTableViewController.product = product
                navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didChooseProductToObserve"), object: nil, userInfo: ["product": product])
                return
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
    
    
    // MARK: - Skeleton data source
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "productTableCell"
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }


    // MARK: - Search Actions
    func updateSearchResults(for searchController: UISearchController) {
            if hasData { filterContentForSearchText(searchController.searchBar.text!) { (searchText) in
                filterProducts = listProducts?.filter({(product: Product) -> Bool in
                    return product.name.lowercased().contains(searchText.lowercased()) || product.id.lowercased().contains(searchText.lowercased())
                })
            }
        }
    }
    
    // MARK: - Actions
    
//    @IBAction func editingMode(_ sender: Any) {
//        if isChosenToObservePrice {
//            navigationController?.popViewController(animated: true)
//            return
//        }
//        if tableView.isEditing {
//            tableView.setEditing(false, animated: true)
//
//            changeTextOfEditingButton(text: "Sửa giá")
//
//            for cell in tableView.visibleCells {
//                let indexPath = tableView.indexPath(for: cell)!
//                hideEditingPen(at: tableView.cellForRow(at: indexPath)!)
//            }
//        }
//        else {
//            tableView.setEditing(true, animated: true)
//            changeTextOfEditingButton(text: "Xong")
//            tableView.allowsSelection = true
//            for cell in tableView.visibleCells {
//                let indexPath: IndexPath = tableView.indexPath(for: cell)!
//                showEditingPen(at: tableView.cellForRow(at: indexPath)!)
//            }
//        }
//    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductDetail" && !tableView.isEditing {
            let vc = segue.destination as! ProductDetailTableViewController
            vc.product = (sender as! Product)
        }
    }
    
    // MARK: - Editing mode
    
//    private func showEditingPen(at cell: UITableViewCell) {
//        UIView.animate(withDuration: 0.3, animations: {
//            let editingCell = cell as! ProductTableViewCell
//            editingCell.editingPen.alpha = 1
//        })
//    }
//
//    private func hideEditingPen(at cell: UITableViewCell) {
//        UIView.animate(withDuration: 0.3, animations: {
//            let editingCell = cell as! ProductTableViewCell
//            editingCell.editingPen.alpha = 0
//        })
//    }
    
    private func presentChangePriceAlert(productIndex: Int) {
        let product = listProducts![productIndex]
        let alert = UIAlertController(title: "Sản phẩm \(product.name)", message: "Nhập giá bạn muốn thay đổi", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textfield in
            textfield.keyboardType = .numberPad
            textfield.borderStyle = .none
            textfield.text = String(product.price)
        })
        
        let cancel = UIAlertAction(title: "Huỷ", style: .destructive, handler: nil)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            guard let newPrice = Int(alert.textFields![0].text!), newPrice > 0 else {
                self.presentAlert(message: "Xin mời nhập đúng giá")
                return
            }

            guard newPrice != product.price else {
                self.presentAlert(message: "Giá không thay đổi")
                return
            }

            let activityIndicator = self.startLoading()
            // 39692647/2716282215/595000
            self.updatePrice(shopId: product.shopId, productId: product.id, newPrice: newPrice) { [unowned self] result in
                switch result {
                case .failed:
                    self.presentAlert(title: "Lỗi không xác định", message: "Vui lòng thử lại sau")
                case .error:
                    self.presentAlert(title: "Lỗi không xác định", message: "Vui lòng thử lại sau")
                case .success:
                    self.presentAlert(title: "Thông báo", message: "Sửa giá thành công")
                    self.listProducts![productIndex].price = newPrice
                    self.tableView.reloadRows(at: [IndexPath(row: productIndex, section: 0)], with: .automatic)
//                default:
//                    break
                }

                self.endLoading(activityIndicator)
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
//    private func changeTextOfEditingButton(text: String) {
//        editingButton.setTitle(text, for: .normal)
//    }
    
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
                self.hasData = false
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
                self.hasData = false
                return
            }

            guard !listProducts.isEmpty else {
                self.tableView.reloadData()
                self.displayNoDataNotification(title: "Cửa hàng chưa có sản phẩm nào", message: "Xin mời quay lại Shopee để thêm sản phẩm")
                self.hasData = false
                return
            }

            print("So san pham la: \(listProducts.count)")

            DispatchQueue.main.async {
                self.listProducts = listProducts
                self.tableView.reloadData()
            }
            self.hasData = true
            self.view.hideSkeleton()
            self.view.stopSkeletonAnimation()
            self.tableView.backgroundView = nil
            self.tableView.allowsSelection = true
        }
    }
    
    // MARK: - Reload Product after changing current Shop
    @objc func reloadProduct(_ notification: Notification) {
        navigationController?.popToRootViewController(animated: false)
        fetchDataFromServer()
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
