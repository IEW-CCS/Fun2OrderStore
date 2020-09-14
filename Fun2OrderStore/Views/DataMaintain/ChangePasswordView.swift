//
//  ChangePasswordView.swift
//  Fun2OrderStore
//
//  Created by Lo Fang Chou on 2020/9/7.
//

import SwiftUI

struct ChangePasswordView: View {
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var newPasswordAgain: String = ""
    
    @EnvironmentObject var userAuth: UserAuth
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("舊密碼")
                    .frame(width: 120, alignment: .leading)
                SecureField("請輸入舊密碼", text: $oldPassword)
                    .foregroundColor(.blue)
            }
            
            HStack {
                Text("新密碼")
                    .frame(width: 120, alignment: .leading)
                SecureField("請輸入新密碼", text: $newPassword)
                    .foregroundColor(.blue)
            }

            HStack {
                Text("再輸入一次")
                    .frame(width: 120, alignment: .leading)
                SecureField("請再輸入一次相同的新密碼", text: $newPasswordAgain)
                    .foregroundColor(.blue)
            }
            
            Button(action: { self.updateNewPassword() }) {
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
        
        Spacer()
    }
    
    func updateNewPassword() {
        print("Click to update store information")
        if oldPassword != userAuth.userControl.userPassword {
            presentSimpleAlertMessage(title: "錯誤訊息", message: "輸入的舊密碼不符，請重新輸入")
            return
        }

        if newPassword != newPasswordAgain {
            presentSimpleAlertMessage(title: "錯誤訊息", message: "輸入的新密碼比對錯誤，請重新輸入")
            return
        }
        
        if newPassword == oldPassword {
            presentSimpleAlertMessage(title: "錯誤訊息", message: "輸入的新密碼不能與舊密碼相同，請重新輸入")
            return
        }
        updateFBLoginPassword(user_auth: userAuth, new_password: newPassword)
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
