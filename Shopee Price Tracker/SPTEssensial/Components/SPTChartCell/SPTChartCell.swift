//
//  SPTChartCell.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/8/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import AAInfographics

class SPTChartCell: UITableViewCell {

    var aaChartView: AAChartView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        setUpChart()
        // Configure the view for the selected state
    }
    
    func setUpChart() {
        let view = contentView
        
        let chartViewWidth = view.frame.size.width
        let chartViewHeight =  view.frame.size.height
        
        
        aaChartView.frame = CGRect(x:0,y:0,width:chartViewWidth + 100, height:chartViewHeight + 10)
        
        
        // set the content height of aachartView
        // aaChartView?.contentHeight = self.view.frame.size.height
        view.addSubview(aaChartView)
        aaChartView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(4)
            make.trailing.equalToSuperview().inset(4)
            make.top.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().inset(4)
        }
    }
    
    func drawChart(type: AAChartType, with product: Product?, and counts: [Int]?) {
        guard let product = product, let counts = counts else {
            return
        }
        aaChartView = AAChartView()
        var data: [[Any]] = []
        var categories = [String]()
        var index = 50
        for count in counts {
            data.append(["\(index)%-\(index+10)%", count])
            categories.append("\(index)%-\(index+10)%")
            index += 10
        }
        
        
        if type == .column {
            self.aaChartView.aa_drawChartWithChartModel(self.chart(type: type, with: data, and: product).colorsTheme(["#1e90ff","#ef476f","#ffd066","#04d69f","#25547c"]).categories(categories).title("Thống kê số lượng sản phẩm theo khoảng giá"))
        }
        else {
            self.aaChartView.aa_drawChartWithChartModel(self.chart(type: type, with: data, and: product).colorsTheme(configureTheRandomColorArray(colorsNumber: 10)).title("Thống kê tỉ lệ sản phẩm theo khoảng giá"))
        }
        
        
    }
    
    private func chart(type: AAChartType, with data: [Any], and product: Product) -> AAChartModel {
        return AAChartModel().chartType(type)//图形类型
            //主题颜色数组
            .axesTextColor(AAColor.black)
            //图形标题
            .subtitle("")//图形副标题
            .dataLabelsEnabled(true)//是否显示数字
            .tooltipValueSuffix(" sản phẩm")//浮动提示框单位后缀
            .animationType(.easeInCubic)//图形渲染动画类型为"bounce"
            .backgroundColor("#00000000")//若要使图表背景色为透明色,可将 backgroundColor 设置为 "rgba(0,0,0,0)" 或 "#00000000". 同时确保 aaChartView!.isClearBackgroundColor = true
            .touchEventEnabled(true)
            .series([
                AASeriesElement()
                    .name("Số lượng")
                    .data(data)
            ]).titleFontSize(18.0)
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
    
}
