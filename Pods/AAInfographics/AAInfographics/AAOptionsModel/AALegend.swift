//
//  AALegend.swift
//  AAInfographicsDemo
//
//  Created by AnAn on 2019/6/26.
//  Copyright © 2019 An An. All rights reserved.
//*************** ...... SOURCE CODE ...... ***************
//***...................................................***
//*** https://github.com/AAChartModel/AAChartKit        ***
//*** https://github.com/AAChartModel/AAChartKit-Swift  ***
//***...................................................***
//*************** ...... SOURCE CODE ...... ***************

/*
 
 * -------------------------------------------------------------------------------
 *
 *  🌕 🌖 🌗 🌘  ❀❀❀   WARM TIPS!!!   ❀❀❀ 🌑 🌒 🌓 🌔
 *
 * Please contact me on GitHub,if there are any problems encountered in use.
 * GitHub Issues : https://github.com/AAChartModel/AAChartKit-Swift/issues
 * -------------------------------------------------------------------------------
 * And if you want to contribute for this project, please contact me as well
 * GitHub        : https://github.com/AAChartModel
 * StackOverflow : https://stackoverflow.com/users/7842508/codeforu
 * JianShu       : https://www.jianshu.com/u/f1e6753d4254
 * SegmentFault  : https://segmentfault.com/u/huanghunbieguan
 *
 * -------------------------------------------------------------------------------
 
 */

import UIKit

public class AALegend: AAObject {
    public var layout: String? //图例数据项的布局。布局类型： "horizontal" 或 "vertical" 即水平布局和垂直布局 默认是：horizontal.
    public var align: String? //设定图例在图表区中的水平对齐方式，合法值有left，center 和 right。
    public var verticalAlign: String? //设定图例在图表区中的垂直对齐方式，合法值有 top，middle 和 bottom。垂直位置可以通过 y 选项做进一步设定。
    public var enabled: Bool?
    public var borderColor: String?
    public var borderWidth: Float?
    public var itemMarginTop: Float? //图例的每一项的顶部外边距，单位px。 默认是：0.
    public var itemMarginBottom: Float?
    public var itemStyle: AAItemStyle?
    public var symbolHeight: Float?
    public var symbolPadding: Float?
    public var symbolRadius: Float?
    public var symbolWidth: Float?
    public var x: Float?
    public var y: Float?
    public var floating: Bool?
    
    @discardableResult
    public func layout(_ prop: AAChartLayoutType?) -> AALegend {
        layout = prop?.rawValue
        return self
    }
    
    @discardableResult
    public func align(_ prop: AAChartAlignType?) -> AALegend {
        align = prop?.rawValue
        return self
    }
    
    @discardableResult
    public func verticalAlign(_ prop: AAChartVerticalAlignType?) -> AALegend {
        verticalAlign = prop?.rawValue
        return self
    }
    
    @discardableResult
    public func enabled(_ prop: Bool?) -> AALegend {
        enabled = prop
        return self
    }
    
    @discardableResult
    public func borderColor(_ prop: String?) -> AALegend {
        borderColor = prop
        return self
    }
    
    @discardableResult
    public func borderWidth(_ prop: Float?) -> AALegend {
        borderWidth = prop
        return self
    }
    
    @discardableResult
    public func itemMarginTop(_ prop: Float?) -> AALegend {
        itemMarginTop = prop
        return self
    }
    
    @discardableResult
    public func itemStyle(_ prop: AAItemStyle?) -> AALegend {
        itemStyle = prop
        return self
    }
    
    @discardableResult
    public func symbolHeight(_ prop: Float?) -> AALegend {
        symbolHeight = prop
        return self
    }
    
    @discardableResult
    public func symbolPadding(_ prop: Float?) -> AALegend {
        symbolPadding = prop
        return self
    }
    
    @discardableResult
    public func symbolRadius(_ prop: Float?) -> AALegend {
        symbolRadius = prop
        return self
    }
    
    @discardableResult
    public func x(_ prop: Float?) -> AALegend {
        x = prop
        return self
    }
    
    @discardableResult
    public func symbolWidth(_ prop: Float?) -> AALegend {
        symbolWidth = prop
        return self
    }
    
    @discardableResult
    public func y(_ prop: Float?) -> AALegend {
        y = prop
        return self
    }
    
    @discardableResult
    public func floating(_ prop: Bool?) -> AALegend {
        floating = prop
        return self
    }
    
    public override init () {
        
    }
    
}

public class AAItemStyle: AAObject {
    public var color: String?
    public var cursor: String?
    public var pointer: String?
    public var fontSize: String?
    public var fontWeight: AAChartFontWeightType?
    
    @discardableResult
    public func color(_ prop: String) -> AAItemStyle {
        color = prop
        return self
    }
    
    @discardableResult
    public func cursor(_ prop: String) -> AAItemStyle {
        cursor = prop
        return self
    }
    
    @discardableResult
    public func pointer(_ prop: String) -> AAItemStyle {
        pointer = prop
        return self
    }
    
    @discardableResult
    public func fontSize(_ prop: Float) -> AAItemStyle {
        fontSize = "\(prop)px"
        return self
    }
    
    @discardableResult
    public func fontWeight(_ prop: AAChartFontWeightType) -> AAItemStyle {
        fontWeight = prop
        return self
    }
    
    public override init() {
        
    }
}
