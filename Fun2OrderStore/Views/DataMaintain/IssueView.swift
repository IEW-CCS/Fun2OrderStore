//
//  IssueView.swift
//  Fun2OrderStore
//
//  Created by Lo Fang Chou on 2020/9/7.
//

import SwiftUI

struct IssueView: View {
    @State var issueTitle: String = ""
    @State var issueContent: String = ""
    @EnvironmentObject var userAuth: UserAuth
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("主旨")
                            .frame(width: 120, alignment: .leading)
                        TextField("問題標題", text: $issueTitle)
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
                        Text("問題內容")
                            .frame(width: 120, alignment: .leading)
                        TextEditor(text: $issueContent)
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
                
                Button(action: { self.sendIssueMail() }) {
                    Text("送出問題")
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
    
    func sendIssueMail() {
        let subjectString: String = "來自『\(userAuth.userControl.brandName)』-『\(userAuth.userControl.storeName)』反應的問題 -- \(issueTitle)"
        EmailHelper.shared.sendEmail(subject: subjectString, body: issueContent, to: "robohood83@gmail.com")
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct IssueView_Previews: PreviewProvider {
    static var previews: some View {
        IssueView()
    }
}
