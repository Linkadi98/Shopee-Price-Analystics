//
//  ProductDetailTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/5/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import Cosmos

class ProductDetailTableViewController: UITableViewController, PriceObserveDelegate {

    // MARK: - Properties
    var product: Product?
    var currentShop: Shop?

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productCode: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var shopName: UILabel!
    var category: UILabel!
    var brand: UILabel!
    var numOfSoldItem: UILabel!
    var inventoryItem: UILabel!
    
    var fiveStar: CosmosView! {
        let star = CosmosView()
        star.rating = Double(NumberStar.five.rawValue)
        star.settings.updateOnTouch = false
        return star
    }
    var fourStar: CosmosView!{
        let star = CosmosView()
        star.rating = Double(NumberStar.four.rawValue)
        star.settings.updateOnTouch = false
        return star
    }
    var threeStar: CosmosView!{
        let star = CosmosView()
        star.rating = Double(NumberStar.three.rawValue)
        star.settings.updateOnTouch = false
        return star
    }
    var twoStar: CosmosView!{
        let star = CosmosView()
        star.rating = Double(NumberStar.two.rawValue)
        star.settings.updateOnTouch = false
        return star
    }
    var oneStar: CosmosView!{
        let star = CosmosView()
        star.rating = Double(NumberStar.one.rawValue)
        star.settings.updateOnTouch = false
        return star
    }
    
    @IBOutlet weak var soldPrice: UILabel!
    @IBOutlet weak var maxPrice: UILabel!
    @IBOutlet weak var minPrice: UILabel!
    @IBOutlet weak var discountPercent: UILabel!
    
    @IBOutlet weak var categoryCell: UITableViewCell!
    @IBOutlet weak var brandCell: UITableViewCell!
    @IBOutlet weak var soldItemCell: UITableViewCell!
    @IBOutlet weak var inventoryCell: UITableViewCell!
    @IBOutlet weak var ratingCell: UITableViewCell!
    
    var stVC: StatisticalPriceTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = false
        tableView.allowsSelection = false
        initializeLabel()
        
        configCellContentView(for: categoryCell, firstItem: "Danh mục", secondItem: category)
        configCellContentView(for: brandCell, firstItem: "Thương hiệu", secondItem: brand)
        configCellContentView(for: soldItemCell, firstItem: "Đã bán", secondItem: numOfSoldItem)
        configCellContentView(for: inventoryCell, firstItem: "Tồn kho", secondItem: inventoryItem)

        guard let currentShop = getObjectInUserDefaults(forKey: "currentShop") as? Shop else {
            return
        }

        self.currentShop = currentShop
//        configRatingCell(rating: 3.4)
    }


    override func viewDidAppear(_ animated: Bool) {
        print("So VC: \(navigationController?.viewControllers.count)")
        guard let currentShop = getObjectInUserDefaults(forKey: "currentShop") as? Shop else {
            self.presentAlert(title: "Lỗi không xác định", message: "Vui lòng thử lại sau")
            return
        }

        if product?.shopId != currentShop.shopId {
            self.navigationController?.popToRootViewController(animated: true)
        }

        update()
    }

    private func update() {
        guard let product = product else {
            self.presentAlert(title: "Lỗi không xác định", message: "Vui lòng thử lại sau")
            return
        }
        productName.text = product.name
        productCode.text = String(product.id)
        soldPrice.text! = String(product.price.convertPriceToVietnameseCurrency()!)
        shopName.text = product.shopId
        configRatingCell(rating: product.rating)
        loadOnlineImage(from: URL(string: product.image)!, to: productImage)
        brand.text = product.brand
        category.text = product.categories.last
        numOfSoldItem.text = String(product.sold)
        inventoryItem.text = String(product.stock)
        maxPrice.text = String(product.maxPrice.convertPriceToVietnameseCurrency()!)
        minPrice.text = String(product.minPrice.convertPriceToVietnameseCurrency()!)
        if let discount = product.discount {
            discountPercent.text = discount
        } else {
            discountPercent.text = "Không có"
        }
    }

    // MARK: - Config cell content view
    
    private func configCellContentView(for cell: UITableViewCell, firstItem text: String, secondItem rightLabel: UILabel) {
        let view = cell.contentView
        let leftLabel = UILabel()
        leftLabel.text = text
        
        view.addSubview(leftLabel)
        view.addSubview(rightLabel)
        
        leftLabel.snp.makeConstraints({(make) in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(15)
        })
        
        rightLabel.snp.makeConstraints({(make) in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(15)
            make.leading.greaterThanOrEqualTo(leftLabel.snp.trailing)
        })
    }
    
    private func initializeLabel() {
        category = UILabel()
        brand = UILabel()
        numOfSoldItem = UILabel()
        inventoryItem = UILabel()
        
        category.text = "Danh muc"
        brand.text = "Thương hiệu"
        numOfSoldItem.text = "Đã bán"
        inventoryItem.text = "Tồn kho"
    }
    
    private func configRatingCell(rating: Double) {
        let view = ratingCell.contentView
        
        let leftLabel = UILabel()
        let ratingLabel = UILabel()
        let stackViewRating = UIStackView()
        
        leftLabel.text = "Đánh giá"
        ratingLabel.text = "\(rating)/5.0"
        ratingLabel.font = UIFont.systemFont(ofSize: 25.0)
        
        stackViewRating.addArrangedSubview(fiveStar)
        stackViewRating.addArrangedSubview(fourStar)
        stackViewRating.addArrangedSubview(threeStar)
        stackViewRating.addArrangedSubview(twoStar)
        stackViewRating.addArrangedSubview(oneStar)
        
        stackViewRating.axis = .vertical
        stackViewRating.spacing = 20
        
        view.addSubview(leftLabel)
        view.addSubview(ratingLabel)
        view.addSubview(stackViewRating)
        
        leftLabel.snp.makeConstraints({(make) in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(15)
        })
        
        stackViewRating.snp.makeConstraints({(make) in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(15)
        })
        
        ratingLabel.snp.makeConstraints({(make) in
            
            make.top.equalToSuperview().inset(90)
            make.trailing.equalTo(stackViewRating.snp.leading).inset(-20)
            make.leading.greaterThanOrEqualToSuperview().inset(100)
        })
        
    }

    
    @IBAction func observeOption(_ sender: Any) {
        
        let option = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let priceOption = UIAlertAction(title: "Thống kê giá sản phẩm này", style: .default, handler: { (action) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didChooseProductToObserve"), object: nil, userInfo: ["product": self.product!])
            self.tabBarController?.selectedIndex = 2
            let navigationVC = self.tabBarController?.selectedViewController as! UINavigationController
            self.stVC = navigationVC.viewControllers.first as! StatisticalPriceTableViewController
            self.stVC?.delegate = self
        })
        
        let rivalOption = UIAlertAction(title: "Xem đối thủ sản phẩm này", style: .default, handler: { [unowned self] (action) in
            let listRivalVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: ListRivalsTableViewController.self)) as! ListRivalsTableViewController
            listRivalVC.product = self.product
            self.navigationController?.pushViewController(listRivalVC, animated: true)
        })
        
        
        let cancel = UIAlertAction(title: "Huỷ", style: .destructive, handler: nil)
        
        
        option.addAction(priceOption)
        option.addAction(rivalOption)
        option.addAction(cancel)
        
        present(option, animated: true, completion: nil)
    }
    
    // MARK: - Pass data
    func getProduct() -> Product {
        return product!
    }
    
    
    
}

enum NumberStar: Int {
    case one = 1, two, three, four, five
}