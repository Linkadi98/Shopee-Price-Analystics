//
//  CategoryTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/19/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import NVActivityIndicatorView

class ProductsTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    // MARK: - Properties

    var vm: ProductTableViewModel!
    var searchController: UISearchController!
    
    var result: ConnectionResults?
    var isChosenToObservePrice = false
    
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

        configVm(vm: ProductTableViewModel(productList: Observable(nil), filterProducts: Observable(nil)))

        guard var currentShop = getObjectInUserDefaults(forKey: "currentShop") as? Shop else {
            return
        }
        
        // Notification
        NotificationCenter.default.addObserver(self, selector: #selector(reloadProduct(_:)), name: .didChangeCurrentShop, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onUpdatePrice()), name: .didUpdateProductPrice, object: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        guard vm.productsList.value != nil else {
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
            return vm.filterProducts.value?.count ?? 0
        }
        return vm.productsList.value?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell

        guard vm.productsList.value != nil else {
            return cell
        }
        
        let product: Product

        if isFiltering(searchController) {
            product = vm.filterProducts.value![indexPath.row]
        }
        else {
            product = vm.productsList.value![indexPath.row]
        }

        DispatchQueue.main.async {
            cell.productName.text = "\(String(describing: product.name))"
            cell.cosmos.rating = product.rating!
            cell.productPrice.text = product.price!.convertPriceToVietnameseCurrency()
            cell.productCode.text = product.id
        }
        loadOnlineImage(from: URL(string: product.image!)!, to: cell.productImage)

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
        
        if vm.productsList.value != nil {
            if isFiltering(searchController) {
                product = vm.filterProducts.value![indexPath.row]
            }
            else {
                product = vm.productsList.value![indexPath.row]
            }

            if isChosenToObservePrice {
//                let statisticalPriceTableViewController = navigationController?.viewControllers[0] as! StatisticalPriceTableViewController
//                statisticalPriceTableViewController.product = product
                navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didChooseProductToObserve"), object: nil, userInfo: ["product": product])
                return
            }
            
        }
    }
    
    // MARK: - Search Actions
    func updateSearchResults(for searchController: UISearchController) {
        if (vm.productsList.value != nil) { filterContentForSearchText(searchController.searchBar.text!) { (searchText) in
                vm.filterProducts.value = (vm.productsList.value?.filter({(product: Product) -> Bool in
                    return (product.name!.lowercased().contains(searchText.lowercased())) || product.id!.lowercased().contains(searchText.lowercased())
                }))!
            }
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let currentShop = getObjectInUserDefaults(forKey: "currentShop") as? Shop else {
            return
        }
        
        if segue.identifier == "ProductDetail" {
            let vc = segue.destination as! ProductDetailTableViewController
            vc.vm?.product.value = sender as! Product
        }
    }
    
    // MARK: - Config View Model
    func configVm(vm: ProductTableViewModel) {
        self.vm = vm
        vm.productsList.bind { products in
            guard products?.count != 0 else {
                self.tableView.reloadData()
                self.displayNoDataNotification(title: "Không có dữ liệu, kiểm tra lại kết nối", message: "Sản phẩm của bạn sẽ hiện tại đây")
                print("bind0")
                return
            }
            
            guard self.result != .error,  let _ = products else {
                self.tableView.reloadData()
                let action = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
                action.setTitle("Kết nối cửa hàng", for: .normal)
                action.backgroundColor = .orange
                action.layer.cornerRadius = 5
                
                self.displayNoDataNotification(title: "Cửa hàng chưa có sản phẩm nào", message: "Xin mời quay lại Shopee để thêm sản phẩm", action: action)
                print("bind1")
                return
            }
            
            guard products != nil else {
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
                let action = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
                action.setTitle("Kết nối cửa hàng", for: .normal)
                action.backgroundColor = .blue

                self.displayNoDataNotification(title: "Chưa kết nối cửa hàng nào", message: "Hãy kết nối cửa hàng ở mục Tài khoản", action: action)
                print("bind2")
                return
            }
            self.tableView.reloadData()
            self.tableView.backgroundView = nil
            self.tableView.allowsSelection = true
        }
        
        print("View Model")
        
    }
    
    // MARK: - Private loading data for this class
    
    private func fetchDataFromServer() {
        print("fetch data")
        
        for row in 0...self.tableView.numberOfRows(inSection: 0) {
            self.tableView.cellForRow(at: IndexPath(row: row, section: 0))?.isHidden = false
        }
        
        tableView.allowsSelection = false
        
        vm.fetchProductFromServer { [unowned self] (result, listProducts) in
            guard result != .failed else {
                self.vm.productsList.value = []
                return
            }

            guard result != .error, let listProducts = listProducts else {
                self.vm!.productsList.value = nil
                return
            }

            guard !listProducts.isEmpty else {
                self.vm!.productsList.value = []
                return
            }

            DispatchQueue.main.async {
                self.vm.productsList.value = listProducts
            }
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
    
    @objc func onUpdatePrice() {
        fetchDataFromServer()
    }
    
}

extension UIView {

    func centerInContainingWindow() {
        guard let window = self.window else { return }

        let windowCenter = CGPoint(x: window.frame.midX, y: window.frame.midY)
        self.center = self.superview!.convert(windowCenter, from: nil)
    }

}
