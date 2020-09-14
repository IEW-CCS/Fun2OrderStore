//
//  ReportView.swift
//  Fun2Order_Store
//
//  Created by Lo Fang Chou on 2020/8/30.
//  Copyright © 2020 JStudio. All rights reserved.
//

import SwiftUI
import Charts

struct ReportView: View {
    @State private var selectedIndex: Int = 0
    private let categories: [String] = ["日報表", "週報表", "月報表"]
    
    var body: some View {
        ScrollView {
            Picker(selection: $selectedIndex, label: Text("")) {
                ForEach(0 ..< categories.count) {
                    Text(self.categories[$0])
                }
            }
            .labelsHidden()
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if selectedIndex == 0 {
                MyBarChartView()
                    .frame(height: 350)
                    .overlay (
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1.5)
                    )
                
                HStack {
                    MyPieChartView()
                        .frame(width: 300, height: 250)
                        .overlay (
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1.5)
                        )

                    LineChartSwiftUI()
                        .frame(width: .infinity, height: 250)
                        .overlay (
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1.5)
                        )

                }
            }
            
            if selectedIndex == 1 {
                MyCombinedChartView()
                    .frame( height: 400)
                    .overlay (
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1.5)
                    )
                
                MyMultiBarChartView()
                    .frame( height: 250)
                    .overlay (
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1.5)
                    )
            }
            
            if selectedIndex == 2 {
                VStack {
                    Text("分店銷售排行")
                        .font(.title)
                        .frame(alignment: .center)
                    SalesReportView()
                        .frame(alignment: .center)
                        .padding([.leading, .trailing], 40)

                }
            }
        }
        .frame(alignment: .center)
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
