//
//  RivalProductDetailViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/12/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

enum RivalProductCase {
    case add, delete
}

class RivalProductDetailViewController: UIViewController {
    
    var vm: RivalProductDetailViewModel?
    
    let COLLECTION_VIEW_CELL = "SPTImageCollectionViewCell"
    var width: CGFloat!
    
    @IBOutlet weak var rivalProductName: UILabel!
    @IBOutlet weak var rivalProductPrice: UILabel!
    @IBOutlet weak var rivalShopName: UILabel!
    
    @IBOutlet weak var handleRivalProductButton: UIButton!
    @IBOutlet weak var status: UILabel!
    
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    
    @IBOutlet weak var collectionImages: UICollectionView!
    
    var rivalProductCase: RivalProductCase?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configViews()
        configViewModel()
        
        collectionImages.delegate = self
        collectionImages.dataSource = self
        // Do any additional setup after loading the view.
        //        screenWidth = UIScreen.main.bounds.width
        width = collectionImages.frame.width
        //        let screenHeight = UIScreen.main.bounds.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        layout.itemSize = CGSize(width: width / 3, height: width / 3)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        collectionImages.collectionViewLayout = layout
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let status = vm?.status ?? false
        setStatus(status)
        changeRoleButton(status)
    }
    
    @IBAction func handleRivalProduct(_ sender: Any) {
        
        if !(vm?.status ?? true) {
            vm?.addRivalPrductToListObservedProduct { result in
                guard result != .failed else {
                    self.setStatus(false)
                    self.changeRoleButton(true)
                    return
                }
                
                NotificationCenter.default.post(name: .didObserveRivalProduct, object: nil)
                self.setStatus(true)
                self.changeRoleButton(false)
            }
        }
        else {
            vm?.deleteChosenRival { result in
                guard result != .failed else {
                    self.setStatus(true)
                    self.changeRoleButton(false)
                    return
                }
                
                NotificationCenter.default.post(name: .didCancelObserveRivalProduct, object: nil)
                self.setStatus(false)
                self.changeRoleButton(true)
            }
        }
    }
    
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func configViewModel() {
        vm?.rivalProduct?.bindAndFire { rivalProduct in
            
            self.rivalProductName.text = rivalProduct.name!
            self.rivalProductPrice.text = "Giá: " +  Int(rivalProduct.price!).convertPriceToVietnameseCurrency()!
            self.setStatus(rivalProduct.auto!)
        }
        
        vm?.rivalShop?.bindAndFire { rivalShop in
            self.rivalShopName.text = "Shop: " + rivalShop.name!
        }
    }
    
    func configViews() {
        handleRivalProductButton.layer.cornerRadius = 5
        headerView.setShadow(cornerRadius: 0, shadowRadius: 5, shadowOffset: CGSize(width: 0, height: -2))
        footerView.setShadow(cornerRadius: 0, shadowRadius: 1, shadowOffset: CGSize(width: 0, height: -2))
    }
    
    func setStatus(_ auto: Bool) {
        if auto {
            status.text = "• Đang theo dõi giá"
            status.textColor = .systemBlue
        }
        else {
            status.text = "• Chưa theo dõi giá"
            status.textColor = .systemRed
        }
    }
    
    func changeRoleButton(_ condition: Bool) {
        if condition {
            handleRivalProductButton.setTitle("Huỷ theo dõi giá sản phẩm", for: .normal)
            handleRivalProductButton.backgroundColor = .systemRed
        }
        else {
            handleRivalProductButton.setTitle("Theo dõi giá sản phẩm", for: .normal)
            handleRivalProductButton.backgroundColor = .systemBlue
        }
    }
}

extension RivalProductDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm?.rivalProduct?.value.images?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UINib(nibName: COLLECTION_VIEW_CELL, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL, for: indexPath) as! SPTImageCollectionViewCell
        
        cell.loadImage(with: vm?.rivalProduct?.value.images?[indexPath.row] ?? "")
        return cell
    }
    
    
}

extension RivalProductDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if vm?.rivalProduct?.value.images?.count == 1 {
            return CGSize(width: width, height: collectionView.frame.height)
        }
        return CGSize(width: width / 3 - 2, height: width / 3 - 2)
    }
}
