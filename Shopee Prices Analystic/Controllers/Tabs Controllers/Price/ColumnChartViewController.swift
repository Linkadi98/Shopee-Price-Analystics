//
//  BarChartViewController.swift
//  Shopee Prices Analystic
//
//  Created by Duy Truong on 8/28/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import AAInfographics

class ColumnChartViewController: UIViewController {

    var product: Product?
    var counts: [Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        let chartViewWidth = self.view.frame.size.width * 0.85
        let chartViewHeight =  self.view.frame.size.height
        let xAxisValue = self.view.frame.size.width * 0.06
        let aaChartView = AAChartView()

        aaChartView.frame = CGRect(x:xAxisValue,y:0,width:chartViewWidth,height:chartViewHeight)

        // set the content height of aachartView
        // aaChartView?.contentHeight = self.view.frame.size.height
        self.view.addSubview(aaChartView)

        aaChartView.aa_drawChartWithChartModel(self.configureColorfulColumnChart(product: product!, counts: counts!))
    }

//    @objc func didReceivedStatistics(_ notification: Notification) {
//        if let counts = notification.userInfo?["counts"] as? [Int] {
//
//        }
//    }

    func configureColorfulColumnChart(product: Product, counts: [Int]) -> AAChartModel {
        var data: [[Any]] = []
        var index = 50
        for count in counts {
            data.append(["\(index)%-\(index+10)%", count])
            index += 10
        }

        return AAChartModel()
            .chartType(.column)
            .title("THEO DÕI GIÁ TRÊN SÀN")
            .subtitle("Sản phẩm: \(product.name))")
            .colorsTheme(configureTheRandomColorArray(colorsNumber: 10))
            .xAxisVisible(false)
            .yAxisVisible(false)
            .series([
                AASeriesElement()
                    .name("Thống kê số lượng trên sàn theo từng khoảng giá")
                    .data(data)
                    .colorByPoint(true),//When using automatic point colors pulled from the options.colors collection, this option determines whether the chart should receive one color per series or one color per point. Default Value：false.
                ])
    }

    private func configureTheRandomColorArray(colorsNumber: Int) -> [Any] {
        let colorStringArr = NSMutableArray()
        for _ in 0 ..< colorsNumber {
            let R = (arc4random() % 256)
            let G = (arc4random() % 256)
            let B = (arc4random() % 256)
            let rgbaColorStr = "rgba(\(R),\(G),\(B),0.9)"
            colorStringArr.add(rgbaColorStr)
        }
        return colorStringArr as! [Any]
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
