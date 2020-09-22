//
//  PostStoreMessageView.swift
//  Fun2OrderStore
//
//  Created by Lo Fang Chou on 2020/9/7.
//

import SwiftUI

struct PostStoreMessageView: View {
    @State private var storeMessage: BrandMessage = BrandMessage()
    @EnvironmentObject var userAuth: UserAuth
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("訊息標題")
                            .frame(width: 120, alignment: .leading)
                        TextField("訊息標題", text: $storeMessage.messageTitle)
                            .frame(width: 180, height: 25)
                            .foregroundColor(.blue)
                            .padding()
                            .overlay (
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1.5)
                            )
                    }
                    .padding()

                    HStack {
                        Text("訊息副標題")
                            .frame(width: 120, alignment: .leading)
                        TextField("訊息副標題", text: $storeMessage.messageSubTitle)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .foregroundColor(.blue)
                            .padding()
                            .overlay (
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1.5)
                            )
                    }
                    .padding()

                    HStack {
                        Text("訊息內容")
                            .frame(width: 120, alignment: .leading)
                        TextEditor(text: $storeMessage.messageDetail)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 200)
                            .foregroundColor(.blue)
                            .padding()
                            .overlay (
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1.5)
                            )
                    }
                    .padding()
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding()
                
                Button(action: { self.sendStoreMessage() }) {
                    Text("送出訊息")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 180, height: 40)
                        .background(BACKGROUND_COLOR_GREEN)
                        .cornerRadius(10.0)
                }

                Spacer()
            }
        }
    }

    func sendStoreMessage() {
        print("Click to send Store Message")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeString = formatter.string(from: Date())
        storeMessage.publishTime = timeString
        print("User's Brand = \(userAuth.userControl.brandName)")
        uploadFBBrandMessage(brand_name: userAuth.userControl.brandName, brand_message: storeMessage)
        notifyAllStores()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func notifyAllStores() {
        downloadFBStoreUserControlList(brand_name: userAuth.userControl.brandName, completion: { userList in
            if userList == nil {
                print("No users to send notification")
                return
            }
            
            var tokenIDs: [String] = [String]()
            for userData in userList! {
                tokenIDs.append(userData.userToken)
            }
            
            if tokenIDs.isEmpty {
                print("No token id found")
                return
            }
            
            var storeNotify: StoreNotificationData = StoreNotificationData()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmssSSS"
            let dateString = formatter.string(from: Date())
            
            storeNotify.createTime = dateString
            storeNotify.notificationType = STORE_NOTIFICATION_TYPE_BRAND_MESSAGE
            
            let sender = PushNotificationSender()
            sender.sendMulticastMessage(to: tokenIDs, title: "公司訊息", body: "來自總公司的訊息，請儘速點閱詳細內容", data: storeNotify, ostype: OS_TYPE_IOS)

        })
    }
}

struct PostStoreMessageView_Previews: PreviewProvider {
    static var previews: some View {
        PostStoreMessageView()
    }
}
