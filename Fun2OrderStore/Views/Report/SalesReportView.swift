//
//  SalesReportView.swift
//  Fun2OrderStore
//
//  Created by Lo Fang Chou on 2020/9/9.
//

import SwiftUI

struct SalesReportView: View {
    private var gridItemLayout: [GridItem] = {
        var gridCount: Int = 5        
        return Array(repeating: .init(.flexible()), count: gridCount)
    }()
    
    var body: some View {
        ScrollView(.horizontal) {
            VStack(alignment: .center, spacing: 0, content: {
                SalesReportRowView(headerFlag: true)
            
                ForEach(salesList, id:\.self) { salesData in
                    SalesReportRowView(rowData: salesData, headerFlag: false)
                }
                
                Spacer()
            })
        }
    }
}

struct SalesReportRowView: View {
    var rowData: SalesReport = SalesReport()
    var headerFlag: Bool = false
    
    var body: some View {
        HStack (alignment: .center, spacing: 0, content: {
            if headerFlag {
                Text("本月排名")
                    .frame(width: 80, alignment: .center)
                    .padding(5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .overlay (
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.gray, lineWidth: 1)
                    )

                Text("分店名稱")
                    .frame(width: 150, alignment: .center)
                    .padding(5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .overlay (
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                Text("上月排名")
                    .frame(width: 80, alignment: .center)
                    .padding(5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .overlay (
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                Text("銷售金額")
                    .frame(width: 100, alignment: .center)
                    .padding(5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .overlay (
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                Text("暢銷商品")
                    .frame(width: 150, alignment: .center)
                    .padding(5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .overlay (
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            } else {
                Text(String(rowData.rank))
                    .frame(width: 80, alignment: .center)
                    .padding(5)
                    .overlay (
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                Text(rowData.storeName)
                    .frame(width: 150, alignment: .center)
                    .padding(5)
                    .overlay (
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                Text(String(rowData.previous_rank))
                    .frame(width: 80, alignment: .center)
                    .padding(5)
                    .overlay (
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                Text(String(rowData.salesMoney))
                    .frame(width: 100, alignment: .trailing)
                    .padding(5)
                    .overlay (
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                Text(rowData.bestSaleProduct)
                    .frame(width: 150, alignment: .center)
                    .padding(5)
                    .overlay (
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
        })
    }
}

struct SalesReportView_Previews: PreviewProvider {
    static var previews: some View {
        SalesReportView()
    }
}
