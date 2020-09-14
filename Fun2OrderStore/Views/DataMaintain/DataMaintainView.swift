//  DataMaintainView.swift
//  Fun2Order_Store
//
//  Created by Lo Fang Chou on 2020/8/30.
//  Copyright © 2020 JStudio. All rights reserved.
//

import SwiftUI

struct DataMaintainView: View {
    @State private var busyState = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("維護基本資料").font(.title)) {
                    NavigationLink(destination: ModifyStoreInformationView().navigationBarTitle("修改店家基本資料", displayMode: .inline)) {
                        Text("修改店家基本資料")
                    }
                    
                    NavigationLink(destination: ChangePasswordView().navigationBarTitle("修改登入密碼", displayMode: .inline)) {
                        Text("修改登入密碼")
                    }
                }
                
                Section(header: Text("店家動態").font(.title)) {
                    NavigationLink(destination: ChangeBusinessHourView().navigationBarTitle("更改營業時間", displayMode: .inline)) {
                        Text("更改營業時間")
                    }
                    
                    NavigationLink(destination: AddToDoItemView().navigationBarTitle("新增代辦事項", displayMode: .inline)) {
                        Text("新增待辦事項")
                    }
                    
                    Toggle(isOn: $busyState) {
                        Text("現在是否忙碌")
                    }
                    
                    NavigationLink(destination: AssignShortageView().navigationBarTitle("指定短缺產品", displayMode: .inline)) {
                        Text("指定短缺產品")
                    }
                }

                Section(header: Text("品牌資料維護").font(.title)) {
                    NavigationLink(destination: PostBrandEventView().navigationBarTitle("發佈品牌活動訊息", displayMode: .inline)) {
                        Text("發佈品牌活動訊息")
                    }
                    
                    NavigationLink(destination: PostStoreMessageView().navigationBarTitle("發佈給店家訊息", displayMode: .inline)) {
                        Text("發佈給店家訊息")
                    }
                    
                    NavigationLink(destination: DiscountPolicyView().navigationBarTitle("設定折扣優惠", displayMode: .inline)) {
                        Text("設定折扣優惠")
                    }
                }
                
                Section(header: Text("其他").font(.title)) {
                    NavigationLink(destination: IssueView().navigationBarTitle("反應問題", displayMode: .inline)) {
                        Text("反應問題")
                    }
                }
            }
            .navigationBarHidden(true)
            //.navigationBarTitle(Text("Home"))
            .edgesIgnoringSafeArea([.top, .bottom])
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .edgesIgnoringSafeArea(.top)
    }
}

struct DataMaintainView_Previews: PreviewProvider {
    static var previews: some View {
        DataMaintainView()
    }
}
