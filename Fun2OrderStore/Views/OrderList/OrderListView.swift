//
//  OrderListView.swift
//  Fun2Order_Store
//
//  Created by Lo Fang Chou on 2020/8/30.
//  Copyright © 2020 JStudio. All rights reserved.
//

import SwiftUI

struct OrderListView: View {
    @State var orderList: [OrderSummaryData] = [OrderSummaryData]()
    @State var showDetailOrder: Bool = false
    @State var selectedOrderData: OrderSummaryData = OrderSummaryData()
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var notificationFunction: NotificationFunctionID

    var gridItemLayout: [GridItem] = {
        var gridCount: Int = 0
        if UIDevice.current.userInterfaceIdiom == .pad {
            gridCount = 2
        } else {
            gridCount = 1
        }
        
        return Array(repeating: .init(.flexible()), count: gridCount)
    }()
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItemLayout, spacing: 10) {
                ForEach(orderList, id:\.self) { orderData in
                    if orderData.orderStatus != ORDER_STATUS_CLOSE {
                        OrderSummaryView(orderData: orderData)
                            .onTapGesture {
                                self.showDetailOrder = true
                                self.selectedOrderData = orderData
                            }
                    }
                }
            }
            .padding()
            .sheet(isPresented: self.$showDetailOrder) {
                OrderDetailView(showFlag: self.$showDetailOrder, orderDetail: self.$selectedOrderData)
            }
            .onAppear() {
                print("OrderListView onAppear starting...")
                self.queryOrderList()
            }
            .onReceive(self.notificationFunction.objectDidChange, perform: { functionID in
                if functionID.functionID == 1 {
                    print("OrderListView onReceive receives functionID change request, start to refresh Order List...")
                    self.queryOrderList()
                }
            })
        }
    }
    
    func queryOrderList() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dayString: String = formatter.string(from: Date())
        
        downloadFBStoreOrderList(brand_name: userAuth.userControl.brandName, store_name: userAuth.userControl.storeName, day_string: dayString, completion: { summaryList in
            if summaryList != nil {
                self.orderList = summaryList!
            }
        })
    }
    
    public func refreshOrderList() {
        print("OrderListView refreshOrderList()")
        self.queryOrderList()
    }
}

struct OrderListView_Previews: PreviewProvider {
    static var previews: some View {
        OrderListView()
    }
}
