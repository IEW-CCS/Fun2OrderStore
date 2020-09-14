//
//  LoginView.swift
//  Fun2Order_Store
//
//  Created by Lo Fang Chou on 2020/9/1.
//  Copyright © 2020 JStudio. All rights reserved.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @Binding public var showModal: Bool
    @EnvironmentObject var userAuth: UserAuth
    
    @State var userName: String = ""
    @State var userPassword: String = ""
    @State var showBrand: Bool = false
    @State var selectedBrandStore: SelectedBrandStoreData = SelectedBrandStoreData()
    
    var brandList: [DetailBrandProfile] =  [DetailBrandProfile]()
    var storeList: [DetailStoreInformation] = [DetailStoreInformation]()
    
    var body: some View {
        ZStack {
            VStack {
                Text("歡迎使用\n『揪Fun』店家系統")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                
                Image("Icon_Login_original")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipped()
                    .padding(.bottom, 20)
                
                Button(action: { self.selectBrandStore() }) {
                    Text("請選擇品牌及分店")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 280, height: 60)
                        .background(BACKGROUND_COLOR_ORANGE)
                        .cornerRadius(15.0)
                }.padding()

                HStack {
                    Text(self.selectedBrandStore.brandName)
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)

                    Text(self.selectedBrandStore.storeName)
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)

                }
                .padding()
                
                TextField("請輸入使用者名稱", text: $userName)
                    .padding()
                    .border(BACKGROUND_COLOR_GREEN, width: 3)
                    .cornerRadius(5.0)
                    .frame(width: 280, height: 40)
                    .padding(.bottom, 20)

                SecureField("請輸入使用者密碼", text: $userPassword)
                    .padding()
                    .border(BACKGROUND_COLOR_GREEN, width: 3)
                    .cornerRadius(5.0)
                    .frame(width: 280, height: 40)
                    .padding(.bottom, 20)
            
                Button(action: { /*self.verifyAuthentication()*/  self.autoLogin() }) {
                    Text("登入")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 280, height: 60)
                        .background(BACKGROUND_COLOR_GREEN)
                        .cornerRadius(15.0)
                }.padding()

            }
            .padding()
            
            if self.showBrand {
                BrandListView(showFlag: self.$showBrand, brandStoreData: $selectedBrandStore)
            }
        }
    }
    
    func verifyAuthentication() {
        if self.selectedBrandStore.brandName == "" {
            presentSimpleAlertMessage(title: "資料錯誤", message: "品牌名稱不能為空白，請重新選擇品牌")
            return
        }

        if self.selectedBrandStore.storeName == "" {
            presentSimpleAlertMessage(title: "資料錯誤", message: "分店名稱不能為空白，請重新選擇分店")
            return
        }
        
        if self.userName == "" {
            presentSimpleAlertMessage(title: "資料錯誤", message: "使用者名稱不能為空白，請重新輸入")
            return
        }

        if self.userPassword == "" {
            presentSimpleAlertMessage(title: "資料錯誤", message: "使用者密碼不能為空白，請重新輸入")
            return
        }

        print("userName = \(self.userName), password = \(self.userPassword)")
        Auth.auth().signIn(withEmail: self.userName, password: self.userPassword) { user, error in
            if error != nil {
                print(error as Any)
                presentSimpleAlertMessage(title: "資料錯誤", message: "使用者名稱或密碼錯誤，請重新輸入正確的資訊")
                userAuth.isLoggedIn = false
                self.showModal = true
                return
            } else {
                downloadFBStoreUserControl(brand_name: self.selectedBrandStore.brandName, user_id: Auth.auth().currentUser!.uid, completion: {userControl in
                    if userControl == nil {
                        presentSimpleAlertMessage(title: "資料錯誤", message: "店家使用者資料存取錯誤")
                        userAuth.isLoggedIn = false
                       return
                    }

                    if userControl!.brandName != self.selectedBrandStore.brandName {
                        presentSimpleAlertMessage(title: "資料錯誤", message: "您無法登入此品牌")
                        userAuth.isLoggedIn = false
                        return
                    }

                    if userControl!.storeName != self.selectedBrandStore.storeName {
                        presentSimpleAlertMessage(title: "資料錯誤", message: "您無法登入此分店")
                        userAuth.isLoggedIn = false
                        return
                    }

                    if userControl!.userEmail != self.userName {
                        presentSimpleAlertMessage(title: "資料錯誤", message: "店家使用者名稱與資料不符")
                        userAuth.isLoggedIn = false
                        return
                    }

                    if userControl!.userPassword != self.userPassword {
                        presentSimpleAlertMessage(title: "資料錯誤", message: "店家使用者密碼與資料不符")
                        userAuth.isLoggedIn = false
                        return
                    }
                    
                    userAuth.userControl = userControl!
                    userAuth.isLoggedIn = true
                    self.showModal = false
                })
            }
        }
    }

    func loginFail() {
        userAuth.isLoggedIn = false
        //self.showModal = false
    }
    
    func selectBrandStore() {
        self.showBrand = true
    }
    
    func autoLogin() {
        Auth.auth().signIn(withEmail: "test123@gmail.com", password: "12345678") { user, error in
            if error != nil {
                print(error as Any)
                presentSimpleAlertMessage(title: "資料錯誤", message: "使用者名稱或密碼錯誤，請重新輸入正確的資訊")
                userAuth.isLoggedIn = false
                self.showModal = true
                return
            } else {
                downloadFBStoreUserControl(brand_name: "上宇林", user_id: Auth.auth().currentUser!.uid, completion: {userControl in
                    if userControl == nil {
                        presentSimpleAlertMessage(title: "資料錯誤", message: "店家使用者資料存取錯誤")
                        userAuth.isLoggedIn = false
                       return
                    }

                    userAuth.userControl = userControl!
                    userAuth.isLoggedIn = true
                    self.showModal = false
                })
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(showModal: .constant(true))
    }
}

