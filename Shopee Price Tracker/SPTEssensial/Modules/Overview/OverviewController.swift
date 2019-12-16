//
//  OverviewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/15/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class OverviewController: UIViewController {
    
    @IBOutlet weak var productStatTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var listShopsTableView: SPTListShops!
    var opagueView: UIView!
    
    let GENERAL_CELL = "SPTGeneralCell"
    
    var vm: OverviewViewModel?
    
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .internetAccess, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNoInternetAccess(_:)), name: .noInternetAccess, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .didChangeCurrentShop, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configStatTableView()
        configListShopsTableView()
        configViewModel(OverviewViewModel(response: Observable((0, 0, 0))))
        
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action:
            #selector(refresh),for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let response = vm?.response?.value, response == (0,0,0) {
            fetchData()
        }
    }
    @IBAction func showListShops(_ sender: Any) {
        showPopup()
    }
    
    func configStatTableView() {
        productStatTableView.delegate = self
        productStatTableView.dataSource = self
        productStatTableView.register(UINib(nibName: GENERAL_CELL, bundle: nil), forCellReuseIdentifier: GENERAL_CELL)
        productStatTableView.layer.cornerRadius = 5
    }
    
    func configListShopsTableView() {
        listShopsTableView = SPTListShops()
        view.addSubview(listShopsTableView)
        
        listShopsTableView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalTo(UIScreen.main.bounds.width - 60)
        }
        
        listShopsTableView.isHidden = true
        listShopsTableView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
    }
    
    
    
    // MARK: Handle Popup
    
    func showPopup() {
        opagueView = UIView()
        view.addSubview(opagueView)
        opagueView.backgroundColor = UIColor(white: 0.25, alpha: 0)
        opagueView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(view.frame.height)
            make.width.equalTo(view.frame.width)
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hidePopup(_:)))
        opagueView.addGestureRecognizer(gesture)
        
        view.bringSubviewToFront(listShopsTableView)
        
        let viewModel = listShopsTableView.vm
        if viewModel?.shops?.value.isEmpty ?? true {
            listShopsTableView.fetchShops()
        }
        
        listShopsTableView.isHidden = false
        UIView.animate(withDuration: 0.1, animations: {
            self.opagueView.backgroundColor = UIColor(white: 0.25, alpha: 0.5)
            self.listShopsTableView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    
    
    @objc func hidePopup(_ sender: UITapGestureRecognizer) {
        listShopsTableView.hideListShopsTableView()
        removeOpagueView()
    }
    
    private func removeOpagueView() {
        UIView.animate(withDuration: 0.1, animations: {
            self.opagueView.backgroundColor = UIColor(white: 0.25, alpha: 0)
        }, completion: { [unowned self] _ in
            self.opagueView.removeFromSuperview()
            self.opagueView = nil
        })
    }

    func configViewModel(_ vm: OverviewViewModel) {
        self.vm = vm
        self.vm?.response?.bind { response in
            self.productStatTableView.reloadData()
        }
    }
    
    func fetchData() {
        vm?.fetchDataFromServer(completion: { totalShopProducts, numberOfAutoAdjustmentProducts, numberOfObservedProductPrice in
            
            self.vm?.response?.value = (totalShopProducts, numberOfAutoAdjustmentProducts, numberOfObservedProductPrice)
        })
    }
    
    @objc func refresh() {
        guard vm?.response != nil else {
            return
        }
        vm?.response?.value = (0,0,0)
        fetchData()
        scrollView.refreshControl?.endRefreshing()
    }
    
    
    @objc func onNoInternetAccess(_ notification: Notification) {
        presentAlert(title: "Mất kết nối mạng", message: "Vui lòng kiểm tra kết nối mạng")
    }
    
}

extension OverviewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GENERAL_CELL, for: indexPath) as! SPTGeneralCell
        
        guard let response = vm?.response?.value else {
            return cell
        }
        
        let row = indexPath.row
        switch row {
        case 0:
            cell.configCell(label: "Tổng sản phẩm cửa hàng", value: response.0)
        case 1:
            cell.configCell(label: "Tự động chỉnh giá", value: response.1)
        case 2:
            cell.configCell(label: "Đang theo dõi giá", value: response.2)
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
