//
//  ChartHelper.swift
//  ClearSky
//
//  Created by Sihem on 20/08/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import UIKit
import Charts

public class ChartHelper{
    
    func initChart(mChart : LineChartView, textColor : UIColor) {
        initStandard(mChart: mChart, textColor: textColor)
        
        mChart.xAxis.enabled = false
        mChart.leftAxis.enabled = false
        mChart.leftAxis.spaceTop = 0.3
        mChart.leftAxis.spaceBottom = 0.3
        mChart.leftAxis.drawGridLinesEnabled = false
        mChart.rightAxis.enabled = false
        
    }
    
    func initChartDialog(mChart : LineChartView, textColor : UIColor) {
        initStandard(mChart: mChart, textColor: textColor)
        
        mChart.xAxis.enabled = false
        mChart.leftAxis.enabled = true
        mChart.leftAxis.spaceTop = 0.3
        mChart.leftAxis.spaceBottom = 0.3
        mChart.leftAxis.drawGridLinesEnabled = false
        mChart.rightAxis.enabled = false
        
    }
    
    func initStandard(mChart : LineChartView, textColor : UIColor){
        
        mChart.chartDescription?.enabled = false
        
        mChart.dragEnabled = true
        mChart.setScaleEnabled(true)
        
        mChart.pinchZoomEnabled = false
        mChart.doubleTapToZoomEnabled = false
        
        mChart.drawGridBackgroundEnabled = false
        mChart.backgroundColor = .white
        
        let data = LineChartData(dataSet: nil)
        data.setValueTextColor(textColor)
        data.setDrawValues(false)
        
        mChart.data = data
        
        let legend = mChart.legend
        legend.enabled = false
        
        mChart.animate(yAxisDuration: 0.5)
        
    }

    func addEntry(mChart : LineChartView, entry : [Double], lineColor: UIColor, draw: Bool){
        let data = mChart.data
        
        var lineChartEntry = [ChartDataEntry]()
        
        for nbEntry in entry {
            lineChartEntry.append(ChartDataEntry(x: Double(lineChartEntry.count + 1), y: nbEntry))
        }
        
        if data != nil {
            let line1 = LineChartDataSet(values: lineChartEntry, label : "Data")
            line1.lineWidth = 2
            line1.circleRadius = 4.0
            line1.drawCircleHoleEnabled = false
            line1.setColor(lineColor)
            line1.setCircleColor(lineColor)
            line1.drawHorizontalHighlightIndicatorEnabled = false
            line1.highlightColor = .orange
            line1.drawValuesEnabled = false
            line1.colors = [lineColor]
            line1.mode = .cubicBezier
            
            let chtd = LineChartData(dataSet: line1)
            
            mChart.data = chtd
        }
        
        mChart.leftAxis.enabled = draw
        mChart.notifyDataSetChanged()
        
    }
}
