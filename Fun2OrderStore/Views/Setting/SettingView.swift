//
//  SettingView.swift
//  Fun2Order_Store
//
//  Created by Lo Fang Chou on 2020/8/30.
//  Copyright © 2020 JStudio. All rights reserved.
//

import SwiftUI
import Firebase

struct SettingView: View {
    @State private var normalTime: String = "20"
    @State private var busyTime: String = "40"
    @State private var openDate: Date = Date()
    @State private var closeDate: Date = Date()
    @State var storeInformation: DetailStoreInformation = DetailStoreInformation()
    @EnvironmentObject var userAuth: UserAuth
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        Form {
            Section(header: Text("登入資料").font(.title)) {
                VStack(alignment: .leading) {
                    Text("品牌： \(userAuth.userControl.brandName)")
                        .fontWeight(.bold)
                        //.foregroundColor(.blue)
                        .frame(alignment: .leading)
                        .padding(5)
        
                    Text("分店： \(userAuth.userControl.storeName)")
                        .fontWeight(.bold)
                        //.foregroundColor(.blue)
                        .frame(alignment: .leading)
                        .padding(5)

                    Text("使用者：\(userAuth.userControl.userEmail)")
                        .fontWeight(.bold)
                        //.foregroundColor(.blue)
                        .frame(alignment: .leading)
                        .padding(5)
                }

                Button(action: { self.logout() }) {
                    Text("登出")
                        .fontWeight(.bold)
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            
            Section(header: Text("設定製作時間").font(.title)) {
                HStack {
                    Text("正常營業開始時間")
                        //.frame(width: 150)

                    DatePicker("", selection: $openDate, displayedComponents: .hourAndMinute)
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                        .accentColor(.blue)
                        .padding()
                        .clipped()
                   //Spacer()
                }

                HStack {
                    Text("正常營業結束時間")
                        //.frame(width: 150)

                    DatePicker("", selection: $closeDate, displayedComponents: .hourAndMinute)
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                        .accentColor(.blue)
                        .padding()
                        .clipped()
                    //Spacer()
                }

                HStack {
                    Text("正常製作時間")
                        //.frame(width: 150)
                    TextField("時間", text: $normalTime)
                        .foregroundColor(Color.blue)
                        .multilineTextAlignment(.trailing)
                    Text("分")
                }
                
                HStack {
                    Text("忙碌製作時間")
                        //.frame(width: 150)
                    
                    TextField("時間", text: $busyTime)
                        .foregroundColor(Color.blue)
                        .multilineTextAlignment(.trailing)
                    Text("分")
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
        .onAppear() {
            downloadFBDetailStoreInformation(brand_name: userAuth.userControl.brandName, store_name: userAuth.userControl.storeName, completion: { storeInfo in
                if storeInfo != nil {
                    self.storeInformation = storeInfo!
                    if self.storeInformation.normalProcessTime == nil {
                        self.normalTime = "0"
                    } else {
                        self.normalTime = String(self.storeInformation.normalProcessTime!)
                    }

                    if self.storeInformation.busyProcessTime == nil {
                        self.busyTime = "0"
                    } else {
                        self.busyTime = String(self.storeInformation.busyProcessTime!)
                    }
                }
            })
        }
    }
    
    func updateSetting() {
        print("Click to update Setting")
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        
        self.storeInformation.normalProcessTime = Int(self.normalTime)
        self.storeInformation.busyProcessTime = Int(self.busyTime)
        if self.storeInformation.businessTime == nil {
            self.storeInformation.businessTime = BusinessTime()
        }
        self.storeInformation.businessTime!.openTime = formatter.string(from: self.openDate)
        self.storeInformation.businessTime!.closeTime = formatter.string(from: self.closeDate)

        updateFBDetailStoreInformation(brand_name: userAuth.userControl.brandName, store_info: self.storeInformation)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }

        userAuth.userControl = StoreUserControl()
        userAuth.isLoggedIn = false
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
