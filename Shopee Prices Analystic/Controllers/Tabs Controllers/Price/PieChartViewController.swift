//
//  PieChartViewController.swift
//  Shopee Prices Analystic
//
//  Created by Duy Truong on 8/28/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import AAInfographics

class PieChartViewController: UIViewController {

    var product: Product?
    var counts: [Int]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        let chartViewWidth = self.view.frame.size.width
        let chartViewHeight =  self.view.frame.size.height
        let aaChartView = AAChartView()

        aaChartView.frame = CGRect(x:0,y:0,width:chartViewWidth,height:chartViewHeight)

        // set the content height of aachartView
        // aaChartView?.contentHeight = self.view.frame.size.height
        self.view.addSubview(aaChartView)
        aaChartView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }

        aaChartView.aa_drawChartWithChartModel(self.configurePieChart(product: product!, counts: counts!))
    }
    
    private func configurePieChart(product: Product, counts: [Int]) -> AAChartModel {
        var data: [[Any]] = []
        var index = 50
        for count in counts {
            data.append(["\(index)%-\(index+10)%", count])
            index += 10
        }
        return AAChartModel()
            .chartType(.pie)
            .backgroundColor("#ffffff")
            .title("THEO DÕI GIÁ TRÊN SÀN")
            .subtitle("Sản phẩm \(product.name)")
            .dataLabelsEnabled(false)
            .yAxisTitle("℃")
            .series([
                AASeriesElement()
                    .name("Số lượng trên sàn")
                    .innerSize("20%")
                    .allowPointSelect(true)
                    .data(data)
                ,
                ]
        )
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
