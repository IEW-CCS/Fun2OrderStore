//
//  OrderDetailView.swift
//  Fun2OrderStore
//
//  Created by Lo Fang Chou on 2020/9/6.
//

import SwiftUI

struct OrderDetailView: View {
    @Binding var showFlag: Bool
    @Binding var orderDetail: OrderSummaryData
    @EnvironmentObject var userAuth: UserAuth
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    VStack {
                        HStack {
                            Text("訂購者：")
                                .fontWeight(.bold)
                                .font(.system(size: 14))
                                //.foregroundColor(Color.white)
                                .padding(5)
                                .frame(width: 100, alignment: .leading)
                            Text(orderDetail.deliveryInfo.contactName)
                                .fontWeight(.bold)
                                .font(.system(size: 14))
                                //.foregroundColor(Color.white)
                                .padding(5)
                            Spacer()
                        }
                        
                        HStack {
                            Text("電話：")
                                .fontWeight(.bold)
                                .font(.system(size: 14))
                                //.foregroundColor(Color.white)
                                .padding(5)
                                .frame(width: 100, alignment: .leading)
                            Text(orderDetail.deliveryInfo.contactPhoneNumber)
                                .fontWeight(.bold)
                                .font(.system(size: 14))
                                //.foregroundColor(Color.white)
                                .padding(5)
                            Spacer()
                        }

                        HStack {
                            Text("取餐時間：")
                                .font(.system(size: 14))
                                .foregroundColor(Color.red)
                                .padding(5)
                                .frame(width: 100, alignment: .leading)
                            Text(orderDetail.deliveryInfo.deliveryTime)
                                .font(.system(size: 14))
                                .foregroundColor(Color.red)
                                .padding(5)
                            Spacer()
                        }
                    }.padding()
                    
                    VStack {
                        if orderDetail.orderStatus == ORDER_STATUS_NEW {
                            Button(action: { self.changeOrderStatus(status_code: ORDER_STATUS_ACCEPT) }) {
                                Text("接受訂單")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(minWidth: 100, maxHeight: 40)
                                    .background(BACKGROUND_COLOR_LIGHTBLUE)
                                    .cornerRadius(15.0)
                            }.padding()

                            Button(action: { self.changeOrderStatus(status_code: ORDER_STATUS_REJECT) }) {
                                Text("拒絕訂單")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(minWidth: 100, maxHeight: 40)
                                    .background(Color.red)
                                    .cornerRadius(15.0)
                            }.padding()
                        }

                        if orderDetail.orderStatus == ORDER_STATUS_ACCEPT {
                            Button(action: { self.changeOrderStatus(status_code: ORDER_STATUS_INPROCESS) }) {
                                Text("製作中")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(minWidth: 100, maxHeight: 40)
                                    .background(BACKGROUND_COLOR_LIGHTBLUE)
                                    .cornerRadius(15.0)
                            }.padding()
                        }

                        if orderDetail.orderStatus == ORDER_STATUS_INPROCESS {
                            Button(action: { self.changeOrderStatus(status_code: ORDER_STATUS_PROCESSEND) }) {
                                Text("製作完畢")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(minWidth: 100, maxHeight: 40)
                                    .background(BACKGROUND_COLOR_LIGHTBLUE)
                                    .cornerRadius(15.0)
                            }.padding()
                        }
                        
                        if orderDetail.orderStatus == ORDER_STATUS_PROCESSEND && orderDetail.deliveryInfo.deliveryType == DELIVERY_TYPE_TAKEOUT {
                            Button(action: { self.changeOrderStatus(status_code: ORDER_STATUS_CLOSE) }) {
                                Text("結單")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(minWidth: 100, maxHeight: 40)
                                    .background(BACKGROUND_COLOR_LIGHTBLUE)
                                    .cornerRadius(15.0)
                            }.padding()
                        }

                        if orderDetail.orderStatus == ORDER_STATUS_PROCESSEND && orderDetail.deliveryInfo.deliveryType == DELIVERY_TYPE_DELIVERY {
                            Button(action: { self.changeOrderStatus(status_code: ORDER_STATUS_DELIVERY) }) {
                                Text("運送中")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(minWidth: 100, maxHeight: 40)
                                    .background(BACKGROUND_COLOR_LIGHTBLUE)
                                    .cornerRadius(15.0)
                            }.padding()

                            Button(action: { self.changeOrderStatus(status_code: ORDER_STATUS_CLOSE) }) {
                                Text("結單")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(minWidth: 100, maxHeight: 40)
                                    .background(BACKGROUND_COLOR_LIGHTBLUE)
                                    .cornerRadius(15.0)
                            }.padding()
                        }
                        
                        if orderDetail.orderStatus == ORDER_STATUS_DELIVERY {
                            Button(action: { self.changeOrderStatus(status_code: ORDER_STATUS_CLOSE) }) {
                                Text("結單")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(minWidth: 100, maxHeight: 40)
                                    .background(BACKGROUND_COLOR_LIGHTBLUE)
                                    .cornerRadius(15.0)
                            }.padding()
                        }
                    }.padding()
                }
                
                VStack(alignment: .center, spacing: 0, content: {
                    OrderDetailProductRowView(headerFlag: true)
                
                    ForEach(orderDetail.productList, id:\.self) { productData in
                        OrderDetailProductRowView(rowData: productData, headerFlag: false)
                    }
                    
                    Spacer()
                })

            }.padding()

        }
    }
    
    func changeOrderStatus(status_code: String) {
        self.orderDetail.orderStatus = status_code
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dayString = formatter.string(from: Date())
        updateFBOrderStatus(user_auth: userAuth, order_data: self.orderDetail, day_string: dayString)
        updateFBUserMenuOrderStatus(user_id: self.orderDetail.ownerUID, order_number: self.orderDetail.orderNumber, status_code: status_code)
    }
}

struct OrderDetailProductRowView: View {
    var rowData: ProductInfo = ProductInfo()
    var headerFlag: Bool = false
    
    var body: some View {
        HStack (alignment: .center, spacing: 0, content: {
            if headerFlag {
                Text("品名")
                    .frame(width: 120, alignment: .center)
                    .padding(5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .overlay (
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.gray, lineWidth: 1)
                    )

                Text("內容")
                    .frame(width: 200, alignment: .center)
                    .padding(5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .overlay (
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text("數量")
                    .frame(width: 80, alignment: .center)
                    .padding(5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .overlay (
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            } else {
                Text(String(rowData.productName))
                    .frame(width: 120, alignment: .center)
                    .padding(5)
                    .overlay (
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text(rowData.productRecipe)
                    .frame(width: 200, alignment: .center)
                    .padding(5)
                    .overlay (
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text(String(rowData.productCount))
                    .frame(width: 80, alignment: .center)
                    .padding(5)
                    .overlay (
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
        })
    }
}

struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailView(showFlag: .constant(true), orderDetail: .constant(OrderSummaryData()))
    }
}
