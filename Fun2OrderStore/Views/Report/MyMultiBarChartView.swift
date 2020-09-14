//
//  MyMultiBarChartView.swift
//  Fun2OrderStore
//
//  Created by Lo Fang Chou on 2020/9/9.
//

import SwiftUI
import Charts

struct MyMultiBarChartView: UIViewRepresentable {
    let barChart = BarChartView()

    func makeUIView(context: UIViewRepresentableContext<MyMultiBarChartView>) -> BarChartView {
        setupBarChart()
        return barChart
    }

    func updateUIView(_ uiView: BarChartView, context: UIViewRepresentableContext<MyMultiBarChartView>) {

    }
    
    func setupBarChart() {
        barChart.chartDescription?.enabled =  false
        
        barChart.pinchZoomEnabled = false
        barChart.drawBarShadowEnabled = false
        
        
        let l = barChart.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = true
        l.font = .systemFont(ofSize: 8, weight: .light)
        l.yOffset = 10
        l.xOffset = 10
        l.yEntrySpace = 0

        let xAxis = barChart.xAxis
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        xAxis.granularity = 1
        xAxis.centerAxisLabelsEnabled = true
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let leftAxis = barChart.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        leftAxis.spaceTop = 0.35
        leftAxis.axisMinimum = 0
        
        barChart.rightAxis.enabled = false

        setBarChartData(10, range: 30)
    }
    
    func setBarChartData(_ count: Int, range: UInt32) {
        let groupSpace = 0.08
        let barSpace = 0.03
        let barWidth = 0.2
        // (0.2 + 0.03) * 4 + 0.08 = 1.00 -> interval per "group"

        let randomMultiplier = range * 100000
        let groupCount = count + 1
        let startYear = 1980
        let endYear = startYear + groupCount
        
        let block: (Int) -> BarChartDataEntry = { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i), y: Double(arc4random_uniform(randomMultiplier)))
        }
        let yVals1 = (startYear ..< endYear).map(block)
        let yVals2 = (startYear ..< endYear).map(block)
        let yVals3 = (startYear ..< endYear).map(block)
        let yVals4 = (startYear ..< endYear).map(block)
        
        let set1 = BarChartDataSet(entries: yVals1, label: "Company A")
        set1.setColor(UIColor(red: 104/255, green: 241/255, blue: 175/255, alpha: 1))
        
        let set2 = BarChartDataSet(entries: yVals2, label: "Company B")
        set2.setColor(UIColor(red: 164/255, green: 228/255, blue: 251/255, alpha: 1))
        
        let set3 = BarChartDataSet(entries: yVals3, label: "Company C")
        set3.setColor(UIColor(red: 242/255, green: 247/255, blue: 158/255, alpha: 1))
        
        let set4 = BarChartDataSet(entries: yVals4, label: "Company D")
        set4.setColor(UIColor(red: 255/255, green: 102/255, blue: 0/255, alpha: 1))
        
        let data = BarChartData(dataSets: [set1, set2, set3, set4])
        data.setValueFont(.systemFont(ofSize: 10, weight: .light))
        //data.setValueFormatter(LargeValueFormatter())
        
        // specify the width each bar should have
        data.barWidth = barWidth

        // restrict the x-axis range
        barChart.xAxis.axisMinimum = Double(startYear)
        
        // groupWidthWithGroupSpace(...) is a helper that calculates the width each group needs based on the provided parameters
        barChart.xAxis.axisMaximum = Double(startYear) + data.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(groupCount)
        
        data.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)

        barChart.data = data
    }

}
