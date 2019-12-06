//
//  AACharts.swift
//  Shopee Prices Analystic
//
//  Created by Duy Truong on 8/28/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation
import AAInfographics

class AACharts {
    func configureColumnChart(productName: String, counts: [Int]) -> AAChartModel {
        var data: [[Any]] = []
        var index = 50
        for count in counts {
            data.append(["\(index)%-\(index+10)%", count])
            index += 10
        }

        return AAChartModel()
            .chartType(.column)
            .title("Theo dõi giá trên sàn Shopee")
            .subtitle("Sản phẩm: \(productName)")
            .colorsTheme(configureTheRandomColorArray(colorsNumber: 10))
            .xAxisVisible(false)
            .yAxisTitle("Số lượng")
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

    func configureMixedLineChart(productName: String, rivalProductName: String, dates: [String], prices: [Int], rivalDates: [String], rivalPrices: [Int]) -> AAChartModel {
        var subDates: [String] = []
        var subPrices: [Int] = []
        var subRivalDates: [String] = []
        var subRivalPrices: [Int] = []

        var numberOfNodes = rivalDates.count
        if numberOfNodes > 8 {
            numberOfNodes = 8
        }

        for index in 0...(numberOfNodes - 1) {
            let reversedIndex = numberOfNodes - 1 - index
            subDates.append(dates[reversedIndex])
            subPrices.append(prices[reversedIndex])
            subRivalDates.append(rivalDates[reversedIndex])
            subRivalPrices.append(rivalPrices[reversedIndex])
        }

        return AAChartModel()
            .chartType(.line)
            .title("")
            .subtitle("Sản phẩm \(productName) và \(rivalProductName)")
            .categories(subDates)
            .yAxisTitle("Giá")
            .dataLabelsEnabled(true)
            .series([
                AASeriesElement()
                    .name("Sản phẩm của bạn")
                    .data(subPrices)
                    //    .zoneAxis("x")
                    .color(AAGradientColor.freshPapaya)
                    .lineWidth(5)
                    .zones([["value": 8],
                            ["dashStyle": AAChartLineDashStyleType.dot.rawValue]
                        ]),
                AASeriesElement()
                    .name("Sản phẩm đối thủ")
                    .color(AAGradientColor.pixieDust)
                    .lineWidth(5)
                    .data(subRivalPrices)
                ])
    }

    private func configurePieChart(productName: String, counts: [Int]) -> AAChartModel {
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
            .subtitle("Sản phẩm : \(productName)")
            .dataLabelsEnabled(true)
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

}
