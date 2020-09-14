//
//  SettingView.swift
//  Fun2Order_Store
//
//  Created by Lo Fang Chou on 2020/8/30.
//  Copyright © 2020 JStudio. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @State private var normalTime: String = "20"
    @State private var busyTime: String = "40"
    @EnvironmentObject var userAuth: UserAuth
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        Form {
            Section(header: Text("登入資料").font(.title)) {
                VStack(alignment: .leading) {
                    Text("品牌： \(userAuth.userControl.brandName)")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .frame(alignment: .leading)
                        .padding(5)
        
                    Text("分店： \(userAuth.userControl.storeName)")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .frame(alignment: .leading)
                        .padding(5)

                    Text("使用者：\(userAuth.userControl.userEmail)")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .frame(alignment: .leading)
                        .padding(5)
                }
            }
            
            Section(header: Text("設定製作時間").font(.title)) {
                HStack {
                    Text("正常營業開始時間")
                    Spacer()
                   //Spacer()
                }

                HStack {
                    Text("正常營業結束時間")
                    Spacer()
                    //Spacer()
                }

                HStack {
                    Text("正常製作時間")
                    Spacer()
                    TextField("時間", text: $normalTime)
                        .foregroundColor(Color.blue)
                    Text("分")
                    //Spacer()
                }
                
                HStack {
                    Text("忙碌製作時間")
                    TextField("時間", text: $busyTime)
                        .foregroundColor(Color.blue)
                    Text("分")
                    //Spacer()
                }
                
                Button(action: { self.updateSetting() }) {
                    Text("更新設定")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 180, height: 40)
                        .background(BACKGROUND_COLOR_GREEN)
                        .cornerRadius(10.0)
                }

            }
        }
    }
    
    func updateSetting() {
        print("Click to update Setting")
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
