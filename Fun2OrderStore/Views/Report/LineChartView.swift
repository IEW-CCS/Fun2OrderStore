//
//  LineChartView.swift
//  Fun2OrderStore
//
//  Created by Lo Fang Chou on 2020/9/8.
//
import SwiftUI
import Charts

struct GraphSwiftUI: View {
    var body: some View {
        GeometryReader { p in
            VStack {
                LineChartSwiftUI()
                    //use frame to change the graph size within your SwiftUI view
                    .frame(width: p.size.width, height: p.size.height/5, alignment: .center)
            }
        }
    }
}

struct LineChartSwiftUI: UIViewRepresentable {
    let lineChart = LineChartView()

    func makeUIView(context: UIViewRepresentableContext<LineChartSwiftUI>) -> LineChartView {
        setUpChart()
        return lineChart
    }

    func updateUIView(_ uiView: LineChartView, context: UIViewRepresentableContext<LineChartSwiftUI>) {

    }

    func setUpChart() {
        lineChart.noDataText = "No Data Available"
        let dataSets = [getLineChartDataSet()]
        let data = LineChartData(dataSets: dataSets)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        lineChart.data = data
    }

    func getChartDataPoints(sessions: [Int], accuracy: [Double]) -> [ChartDataEntry] {
        var dataPoints: [ChartDataEntry] = []
        for count in (0..<sessions.count) {
            dataPoints.append(ChartDataEntry.init(x: Double(sessions[count]), y: accuracy[count]))
        }
        return dataPoints
    }

    func getLineChartDataSet() -> LineChartDataSet {
        let dataPoints = getChartDataPoints(sessions: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], accuracy: [10.0, 40.0, 30.0, 33.0, 56.0, 78.0, 92.0, 60.0, 45.0, 88.0])
        let set = LineChartDataSet(entries: dataPoints, label: "Sales")
        set.lineWidth = 2.5
        set.circleRadius = 4
        set.circleHoleRadius = 2
        let color = ChartColorTemplates.vordiplom()[0]
        set.setColor(color)
        set.setCircleColor(color)
        return set
    }
}

struct GraphSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        GraphSwiftUI()
    }
}
