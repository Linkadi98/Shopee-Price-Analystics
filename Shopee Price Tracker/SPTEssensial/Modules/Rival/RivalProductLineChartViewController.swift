//
//  RivalProductLineChartViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/7/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import AAInfographics

class RivalProductLineChartViewController: UIViewController {

    var product: Product?
    var rival: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let chartViewWidth  = self.view.frame.size.width
        let chartViewHeight = self.view.frame.size.height
        let aaChartView = AAChartView()
        aaChartView.frame = CGRect(x:0,y:0,width:chartViewWidth * 0.75,height:chartViewHeight * 0.75)
        // set the content height of aachartView
        // aaChartView?.contentHeight = self.view.frame.size.height
        self.view.addSubview(aaChartView)
        aaChartView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }

//        let activityIndicator = startLoading()
        fetchData { (dates, prices, rivalDates, rivalPrices) in
            if dates != nil {
                aaChartView.aa_drawChartWithChartModel(AACharts().configureMixedLineChart(productName: self.product!.name, rivalProductName: self.rival!.name, dates: dates!, prices: prices!, rivalDates: rivalDates!, rivalPrices: rivalPrices!))
            }
//            self.endLoading(activityIndicator)
            print("Done drawing")
        }
    }

    private func fetchData(completion: @escaping ([String]?, [Int]?, [String]?, [Int]?) -> Void) {
        priceObservations(productId: product!.id) { (result, dates, prices) in
            print("670")
            if result == .failed {
                self.presentAlert(title: "Thông báo", message: "Sản phẩm chưa được ghi nhận lịch sử")
                completion(nil, nil, nil, nil)
            } else if result == .success {
                self.priceObservations(productId: self.rival!.id, completion: { (result2, rivalDates, rivalPrices) in
                    print("671")
                    if result == .failed {
                        self.presentAlert(title: "Thông báo", message: "Sản phẩm chưa được ghi nhận lịch sử")
                        completion(nil, nil, nil, nil)
                    } else if result2 == .success {
                        completion(dates!, prices!, rivalDates!, rivalPrices!)
                    }
                })
            }
        }
    }
}
