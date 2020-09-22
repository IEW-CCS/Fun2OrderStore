//
//  OrderSummaryView.swift
//  Fun2Order_Store
//
//  Created by Lo Fang Chou on 2020/9/4.
//  Copyright © 2020 JStudio. All rights reserved.
//

import SwiftUI

struct OrderSummaryView: View {
    var orderData: OrderSummaryData
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Label(getOrderStatusString(status_code: orderData.orderStatus), systemImage: "paperclip")
                        .padding(2)
                        .frame(maxWidth: .infinity, minHeight: 40, alignment: .center)
                        .foregroundColor(.white)
                        //.background(Color.red)
                }
                .background(getOrderStatusColor(status_code: orderData.orderStatus))
                .cornerRadius(10.0)

                HStack {
                    Text("訂購者：")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(5)
                        .frame(width: 100, alignment: .leading)
                    Text(orderData.deliveryInfo.contactName)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(5)
                    Spacer()
                }
                
                HStack {
                    Text("電話：")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(5)
                        .frame(width: 100, alignment: .leading)
                    Text(orderData.deliveryInfo.contactPhoneNumber)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(5)
                    Spacer()
                }
                
                HStack {
                    Text("訂購時間：")
                        .foregroundColor(Color.white)
                        .padding(5)
                        .frame(width: 100, alignment: .leading)
                    //Text(orderData.updateTime)
                    Text(convertOrderTime(order_time: orderData.updateTime))
                        .foregroundColor(Color.white)
                        .padding(5)
                    Spacer()
                }

                HStack {
                    Text("取餐時間：")
                        .foregroundColor(Color.red)
                        .padding(5)
                        .frame(width: 100, alignment: .leading)
                    Text(orderData.deliveryInfo.deliveryTime)
                        .foregroundColor(Color.red)
                        .padding(5)
                    Spacer()
                }

                HStack {
                    VStack(alignment: .center) {
                        Text("數量")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding(5)
                        Text(String(orderData.totalCount))
                            .fontWeight(.bold)
                            .font(.largeTitle)
                            .padding(5)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                    .padding(10)
                    .background(Color.blue)
                    .cornerRadius(10)

                    VStack(alignment: .center) {
                        Text("價格")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding(5)
                        Text(String(orderData.totalPrice))
                            .fontWeight(.bold)
                            .font(.largeTitle)
                            .padding(5)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                    .padding(10)
                    .background(Color.orange)
                    .cornerRadius(10)
                }
            }
            .padding()
        }
        .overlay(
            HStack {
                Spacer()
                VStack {
                    Button(action: {self.closeOrder()}, label: {
                    Image(systemName: "xmark.circle")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                    })
                    .padding(.trailing, 18)
                    .padding(.top, 18)
                    Spacer()
                }
            }
        )
        .background(BACKGROUND_COLOR_DEEPBLUE)
        .cornerRadius(10)
        .overlay (
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.secondary, lineWidth: 1.5)
        )
        .padding(10)

    }
    
    func closeOrder() {
        print("Click the close button")
        print("Order updateTime = \(orderData.updateTime)")
        //if let index = testOrderList.firstIndex(where: {$0.updateTime == orderData.updateTime}) {
        //    testOrderList.remove(at: index)
        //}
    }
    
    func convertOrderTime(order_time: String) -> String {
        var returnString: String = ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = DATETIME_FORMATTER
        let orderDate = formatter.date(from: order_time)
        formatter.dateFormat = TAIWAN_DATETIME_FORMATTER2
        returnString = formatter.string(from: orderDate!)
        
        return returnString
    }
}

struct OrderSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        OrderSummaryView(orderData: OrderSummaryData())
    }
}
