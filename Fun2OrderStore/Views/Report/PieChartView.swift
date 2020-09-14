//
//  PieChartView.swift
//  Fun2OrderStore
//
//  Created by Lo Fang Chou on 2020/9/8.
//

import SwiftUI
import Charts

struct MyPieChartView: UIViewRepresentable {
    let pieChart = PieChartView()
    let labels: [String] = ["頂級茶道", "濃郁雪浮", "純天然鮮奶", "口感鮮茶"]

    func makeUIView(context: UIViewRepresentableContext<MyPieChartView>) -> PieChartView {
        setupPieChart()
        return pieChart
    }

    func updateUIView(_ uiView: PieChartView, context: UIViewRepresentableContext<MyPieChartView>) {

    }

    func setupPieChart() {
        let l = self.pieChart.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .top
        l.orientation = .horizontal
        l.direction = .leftToRight
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        
        pieChart.entryLabelColor = .black
        pieChart.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        pieChart.animate(xAxisDuration: 1.0, easingOption: .easeOutBack)
        pieChart.drawHoleEnabled = true
        pieChart.holeColor = .clear
        pieChart.drawEntryLabelsEnabled = false
        pieChart.drawSlicesUnderHoleEnabled = false
        pieChart.holeRadiusPercent = 0.45
        setChartData(data_array: [50, 40, 30, 60])
    }
    
    func setChartData(data_array: [Int]) {
        var dataEntries: [PieChartDataEntry] = []
        
        if data_array.isEmpty {
            return
        }
        
        for index in 0...data_array.count - 1 {
            let entry = PieChartDataEntry(value: Double(data_array[index]), label: self.labels[index])
            entry.data = Int()
            entry.data = index
            dataEntries.append(entry)
        }
        
        let set = PieChartDataSet(entries: dataEntries, label: "")
        //let set = PieChartDataSet(entries: dataEntries)
        set.drawIconsEnabled = false
        set.sliceSpace = 4

        set.colors = [SUMMARY_WAIT_COLOR, SUMMARY_ACCEPT_COLOR, SUMMARY_REJECT_COLOR, SUMMARY_EXPIRE_COLOR]
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .decimal
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        //pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 16, weight: .light))
        data.setValueTextColor(.black)
        
        pieChart.data = data
        pieChart.highlightValues(nil)
        pieChart.animate(xAxisDuration: 1.0, easingOption: .easeOutBack)
    }

}


