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
import JGProgressHUD

class ProductsTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    // MARK: - Properties

    var vm: ProductTableViewModel!
    var searchController: UISearchController!
    
    var result: ConnectionResults?
    
    var hud: SPTProgressHUD!
    
    override func awakeFromNib() {
        // Notification
        NotificationCenter.default.addObserver(self, selector: #selector(reloadProduct(_:)), name: .didChangeCurrentShop, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onUpdatePrice(_ :)), name: .didUpdateProductPrice, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .internetAccess, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNoInternetAccess(_:)), name: .noInternetAccess, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .didChangeCurrentShop, object: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        
        setupSearchController(for: searchController, placeholder: "Tên, mã, hoặc giá sản phẩm")
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl?.tintColor = UIColor.blue

        configVm(vm: ProductTableViewModel(productList: Observable(nil), filterProducts: Observable(nil)))
        
        setShadowForNavigationBar()
        self.extendedLayoutIncludesOpaqueBars = true
    }

    override func viewDidAppear(_ animated: Bool) {
        guard vm.productsList.value != nil else {
            fetchDataFromServer()
            return
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.view.setNeedsLayout() // force update layout
        navigationController?.view.layoutIfNeeded()
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
            cell.productName.text = String(describing: product.name ?? "")
            cell.cosmos.rating = Double(product.ratingStar ?? 0)
            cell.productPrice.text = Int(product.price!).convertPriceToVietnameseCurrency()
            cell.productCode.text = String(describing: product.itemid ?? 0)
            Network.shared.loadOnlineImage(from:
                URL(string: product.images![0])!,
                                           to: cell.productImage)
        }
        print(URL(string: product.images![0])!)
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: tableView.rowHeight, duration: 0.3, delayFactor: 0.03)
//        let animator = Animator(animation: animation)
//        animator.animate(cell: cell, at: indexPath, in: tableView)
//        tableView.scrollsToTop = true
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
            
            performSegue(withIdentifier: "ProductDetail", sender: product)
        }
    }
    
    // MARK: - Search Actions
    func updateSearchResults(for searchController: UISearchController) {
        if (vm.productsList.value != nil) { filterContentForSearchText(searchController.searchBar.text!) { (searchText) in
                vm.filterProducts.value = (vm.productsList.value?.filter({(product: Product) -> Bool in
                    return (product.name!.lowercased().contains(searchText.lowercased())) ||
                        String(describing: product.itemid!).lowercased().contains(searchText.lowercased()) ||
                        product.name!.folding(options: .diacriticInsensitive, locale: .current).lowercased().contains(searchText.lowercased())
                }))!
            }
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductDetail" {
            let vc = segue.destination as! ProductTableContainerViewController
            vc.vm = ProductTableContainerViewModel()
            vc.vm!.product = Observable(sender as! Product)
            vc.hidesBottomBarWhenPushed = true
        }
    }
    
    // MARK: - Config View Model
    func configVm(vm: ProductTableViewModel) {
        self.vm = vm
        self.vm.productsList.bind { products in
            
            guard products?.count != 0 else {
                self.tableView.reloadData()
                self.displayNoDataNotification(title: "Có lỗi xảy ra", message: "Kiểm tra lại kết nối", hudError: "Lỗi kết nối")
                return
            }
            
            guard self.result != .error,  let _ = products else {
                self.tableView.reloadData()
                let action = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
                action.setTitle("Kết nối cửa hàng", for: .normal)
                action.backgroundColor = .orange
                action.layer.cornerRadius = 5
                
                self.displayNoDataNotification(title: "Cửa hàng chưa có sản phẩm nào", message: "Bạn hãy quay lại Shopee để thêm sản phẩm", action: action)
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
                return
            }
            self.tableView.reloadData()
            self.tableView.backgroundView = nil
            self.tableView.allowsSelection = true
        }
    }
    
    // MARK: - Private loading data for this class
    
    fileprivate func showProgressHUD() {
        hud = SPTProgressHUD(style: .dark)
        hud.show(in: tableView, content: "Đang tải")
    }
    
    private func fetchDataFromServer() {

        showProgressHUD()

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
                self.vm!.productsList.value = []
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
        guard vm != nil else {
            return
        }
        vm.productsList.value = []
        tableView.backgroundView = nil
        fetchDataFromServer()
        tableView.refreshControl?.endRefreshing()
    }
    
    @objc func onUpdatePrice(_ notification: Notification) {
        fetchDataFromServer()
    }
    
    @objc func onNoInternetAccess(_ notification: Notification) {
        guard vm != nil else {
            return
        }
        vm.productsList.value = []
        presentAlert(title: "Mất kết nối mạng", message: "Vui lòng kiểm tra kết nối mạng")
    }
    
}

