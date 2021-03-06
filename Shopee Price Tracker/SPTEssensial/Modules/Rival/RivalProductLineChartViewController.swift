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
    var rivalProduct: Product?
    
    var aaChartView: AAChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chartViewWidth  = self.view.frame.size.width
        let chartViewHeight = self.view.frame.size.height
        aaChartView = AAChartView()
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData { (dates, prices, rivalDates, rivalPrices) in
            if dates != nil {
                self.aaChartView.aa_drawChartWithChartModel(AACharts().configureMixedLineChart(productName: self.product!.name!, rivalProductName: (self.rivalProduct?.name)!, dates: dates!, prices: prices!, rivalDates: rivalDates!, rivalPrices: rivalPrices!))
            }
            //            self.endLoading(activityIndicator)
            print("Done drawing")
        }
    }

    private func fetchData(completion: @escaping ([String]?, [Int]?, [String]?, [Int]?) -> Void) {
        PriceApiService.priceObservations(productId: product?.itemid ?? 0) { (result, dates, prices) in
            if result == .failed {
                self.presentAlert(title: "Thông báo", message: "Không có dữ liệu")
                completion(nil, nil, nil, nil)
            } else if result == .success {
                PriceApiService.priceObservations(productId: (self.rivalProduct?.itemid)!, completion: { (result2, rivalDates, rivalPrices) in
                    if result == .failed {
                        self.presentAlert(title: "Thông báo", message: "Không có dữ liệu")
                        completion(nil, nil, nil, nil)
                    } else if result2 == .success {
                        completion(dates!, prices!, rivalDates!, rivalPrices!)
                    }
                })
            }
        }
    }
}
