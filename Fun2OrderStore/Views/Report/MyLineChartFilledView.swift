//
//  MyLineChartFilledView.swift
//  Fun2OrderStore
//
//  Created by Lo Fang Chou on 2020/9/8.
//

import SwiftUI
import Charts

struct MyLineChartFilledView: UIViewRepresentable {
    let lineChart = LineChartView()

    func makeUIView(context: UIViewRepresentableContext<MyLineChartFilledView>) -> LineChartView {
        setupLineChartFilled()
        return lineChart
    }

    func updateUIView(_ uiView: LineChartView, context: UIViewRepresentableContext<MyLineChartFilledView>) {

    }
    
    func setupLineChartFilled() {
        //lineChart.backgroundColor = UIColor(Color.secondary)
        lineChart.gridBackgroundColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 150/255)
        lineChart.drawGridBackgroundEnabled = true
        
        lineChart.drawBordersEnabled = true
        
        lineChart.chartDescription?.enabled = false
        
        lineChart.pinchZoomEnabled = false
        lineChart.dragEnabled = true
        lineChart.setScaleEnabled(true)
        
        lineChart.legend.enabled = false
        
        lineChart.xAxis.enabled = false
        
        let leftAxis = lineChart.leftAxis
        leftAxis.axisMaximum = 900
        leftAxis.axisMinimum = -250
        leftAxis.drawAxisLineEnabled = false
        
        lineChart.rightAxis.enabled = false
        
        setLineChartFilledData(30, range: 50)
    }
    
    func setLineChartFilledData(_ count: Int, range: UInt32) {
        let yVals1 = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 50)
            return ChartDataEntry(x: Double(i), y: val)
        }
        let yVals2 = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 450)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(entries: yVals1, label: "DataSet 1")
        set1.axisDependency = .left
        set1.setColor(UIColor(red: 255/255, green: 241/255, blue: 46/255, alpha: 1))
        set1.drawCirclesEnabled = false
        set1.lineWidth = 2
        set1.circleRadius = 3
        set1.fillAlpha = 1
        set1.drawFilledEnabled = true
        set1.fillColor = .white
        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set1.drawCircleHoleEnabled = false
        set1.fillFormatter = DefaultFillFormatter { _,_  -> CGFloat in
            return CGFloat(self.lineChart.leftAxis.axisMinimum)
        }
        
        let set2 = LineChartDataSet(entries: yVals2, label: "DataSet 2")
        set2.axisDependency = .left
        set2.setColor(UIColor(red: 255/255, green: 241/255, blue: 46/255, alpha: 1))
        set2.drawCirclesEnabled = false
        set2.lineWidth = 2
        set2.circleRadius = 3
        set2.fillAlpha = 1
        set2.drawFilledEnabled = true
        set2.fillColor = .white
        set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set2.drawCircleHoleEnabled = false
        set2.fillFormatter = DefaultFillFormatter { _,_  -> CGFloat in
            return CGFloat(self.lineChart.leftAxis.axisMaximum)
        }

        let data = LineChartData(dataSets: [set1, set2])
        data.setDrawValues(false)
        
        lineChart.data = data
    }
}
