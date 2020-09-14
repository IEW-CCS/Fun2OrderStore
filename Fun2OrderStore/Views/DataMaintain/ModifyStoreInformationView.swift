//
//  ModifyStoreInformationView.swift
//  Fun2OrderStore
//
//  Created by Lo Fang Chou on 2020/9/7.
//

import SwiftUI

struct ModifyStoreInformationView: View {
    @State var storeInformation: DetailStoreInformation = DetailStoreInformation()
    @EnvironmentObject var userAuth: UserAuth
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>


    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("店家名稱")
                    .frame(width: 120, alignment: .leading)
                //TextField("姓名", text: storeInformation.)
                //    .foregroundColor(.blue)
                Text(storeInformation.storeName)
            }
            
            HStack {
                Text("聯絡電話")
                    .frame(width: 120, alignment: .leading)
                TextField("電話號碼", text: $storeInformation.storePhoneNumber.bound)
                    .foregroundColor(.blue)
            }

            HStack {
                Text("地址")
                    .frame(width: 120, alignment: .leading)
                TextField("詳細地址", text: $storeInformation.storeAddress.bound)
                    .foregroundColor(.blue)
            }

            HStack {
                Text("Facebook網址")
                    .frame(width: 120, alignment: .leading)
                TextField("網址", text: $storeInformation.storeFacebookURL.bound)
                    .foregroundColor(.blue)
            }
            
            HStack {
                Text("Instagram網址")
                    .frame(width: 120, alignment: .leading)
                TextField("網址", text: $storeInformation.storeInstagramURL.bound)
                    .foregroundColor(.blue)
            }
            Button(action: { self.updateStoreInformation() }) {
                Text("更新資料")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 180, height: 40)
                    .background(BACKGROUND_COLOR_GREEN)
                    .cornerRadius(10.0)
            }

        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding()
        .onAppear() {
            self.queryStoreInformation()
        }
        Spacer()
    }
    
    func queryStoreInformation() {
        downloadFBStoreInformation(brand_name: userAuth.userControl.brandName, store_name: userAuth.userControl.storeName, completion: { storeData in
            if storeData != nil {
                self.storeInformation = storeData!
                //print("self.storeInformation = \(self.storeInformation)")
            }
        })
    }
    
    func updateStoreInformation() {
        print("Click to update store information")
        updateFBStoreInformation(user_auth: userAuth, store_info: self.storeInformation)
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct ModifyStoreInformationView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyStoreInformationView()
    }
}
