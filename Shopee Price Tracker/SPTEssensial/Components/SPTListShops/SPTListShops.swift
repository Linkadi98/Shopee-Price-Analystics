//
//  SPTListShops.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/15/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class SPTListShops: BaseView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var listShopTableView: UITableView!
    @IBOutlet weak var titleTableView: UILabel!
    
    var vm: SPTListShopsViewModel?
    
    let SHOP_CELL = "SPTShopCell"
    let XIB_NAME = "SPTListShops"
    
    override class func awakeFromNib() {
        let center = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(refresh), name: .didChangeCurrentShop, object: nil)
        
        center.addObserver(self, selector: #selector(refresh), name: .internetAccess, object: nil)
    }
    
    override func commonInit() {
        let bundle = Bundle.init(for: SPTListShops.self)
        if
            let viewsToAdd = bundle.loadNibNamed(XIB_NAME,
                                                 owner: self,
                                                options: nil),
            let contentView = viewsToAdd.first as? UIView {
            
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight,
                                            .flexibleWidth]
        }
        contentView.layer.cornerRadius = 5
        configTableView()
        configViewModel(SPTListShopsViewModel(shops: Observable([])))
        fetchShops()
    }
    
    func configTableView() {
        listShopTableView.delegate = self
        listShopTableView.dataSource = self
        listShopTableView.layer.cornerRadius = 5
        titleTableView.layer.cornerRadius = 5
        titleTableView.layer.masksToBounds = true
        listShopTableView.layer.maskedCorners = [.layerMinXMaxYCorner,
                                                 .layerMaxXMaxYCorner]
        titleTableView.layer.maskedCorners = [.layerMaxXMinYCorner,
                                              .layerMinXMinYCorner]
        listShopTableView.register(UINib(nibName: SHOP_CELL, bundle: nil), forCellReuseIdentifier: SHOP_CELL)
    }
    
    func hideListShopsTableView() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }, completion: { _ in
            self.isHidden = true
        })
    }
}

extension SPTListShops: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm?.shops?.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SHOP_CELL, for: indexPath) as! SPTShopCell
        
        guard let shop = vm?.shops?.value[indexPath.row], let currentShop = UserDefaults.standard.getObjectInUserDefaults(forKey: "currentShop") as? Shop else {
            return cell
        }
        
        cell.configCell(shopName: shop.name!, isCurrentShop: shop.shopid == currentShop.shopid)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    func configViewModel(_ vm: SPTListShopsViewModel) {
        self.vm = vm
        self.vm?.shops?.bind { shops in
            guard !shops.isEmpty else {
                return
            }
            self.listShopTableView.reloadData()
        }
    }
    
    @objc func refresh() {
        guard vm != nil else {
            return
        }
        fetchShops()
    }
    
    func fetchShops() {
        vm?.fetchShops { result, shops in
            guard result != .failed , let shops = shops else {
                return
            }
            
            self.vm?.shops?.value = shops
        }
    }
}
