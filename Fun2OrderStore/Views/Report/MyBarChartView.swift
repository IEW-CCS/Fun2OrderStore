//
//  MyBarChartView.swift
//  Fun2OrderStore
//
//  Created by Lo Fang Chou on 2020/9/8.
//

import SwiftUI
import Charts

struct MyBarChartView: UIViewRepresentable {
    let barChart = BarChartView()
    let ITEM_COUNT = 12

    func makeUIView(context: UIViewRepresentableContext<MyBarChartView>) -> BarChartView {
        setupBarChart()
        return barChart
    }

    func updateUIView(_ uiView: BarChartView, context: UIViewRepresentableContext<MyBarChartView>) {

    }
    
    func setupBarChart() {
        barChart.chartDescription?.enabled = false
                
        barChart.dragEnabled = true
        barChart.setScaleEnabled(true)
        barChart.pinchZoomEnabled = false
                        
        barChart.rightAxis.enabled = false
        barChart.drawBarShadowEnabled = false
        barChart.drawValueAboveBarEnabled = false
        
        barChart.maxVisibleCount = 60
        
        let xAxis = barChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        //xAxis.valueFormatter = DayAxisValueFormatter(chart: barChart)
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = " $"
        leftAxisFormatter.positiveSuffix = " $"
        
        let leftAxis = barChart.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
        
        let rightAxis = barChart.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.labelCount = 8
        rightAxis.valueFormatter = leftAxis.valueFormatter
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        
        let l = barChart.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 9
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4

        setBarChartData(20, range: 30)
    }
    
    func setBarChartData(_ count: Int, range: UInt32) {
        let start = 1
        
        let yVals = (start..<start+count+1).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(mult))
            if arc4random_uniform(100) < 25 {
                return BarChartDataEntry(x: Double(i), y: val, icon: UIImage(named: "icon"))
            } else {
                return BarChartDataEntry(x: Double(i), y: val)
            }
        }
        
        var set1: BarChartDataSet! = nil
        if let set = barChart.data?.dataSets.first as? BarChartDataSet {
            set1 = set
            set1.replaceEntries(yVals)
            barChart.data?.notifyDataChanged()
            barChart.notifyDataSetChanged()
        } else {
            set1 = BarChartDataSet(entries: yVals, label: "The year 2017")
            set1.colors = ChartColorTemplates.material()
            set1.drawValuesEnabled = false
            
            let data = BarChartData(dataSet: set1)
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
            data.barWidth = 0.9
            barChart.data = data
        }
    }
}
