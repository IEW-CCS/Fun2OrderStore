//
//  ModalView.swift
//  Fun2Order_Store
//
//  Created by Lo Fang Chou on 2020/9/1.
//  Copyright © 2020 JStudio. All rights reserved.
//

import SwiftUI

struct ModalView<Content: View>: View {
    @Binding var showModal: Bool
    let content: Content // content of the modal

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundColor(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                .shadow(color: Color.gray.opacity(0.4), radius: 4)
            
            ScrollView {
                content
            }.padding(.vertical, 40)
            
            VStack {
                Spacer()
                //ModalButton(showModal: self.$showModal)
            }.padding(.vertical)
            
        }
        .padding(50)
    }
}

/*
extension ModalView {
    struct ModalButton: View {
        @Binding var showModal: Bool
        
        var body: some View {
            // button to search a new handle
            Button(action: {
                self.showModal = false
                print("close modal")
            }) {
                Text("Close Insight")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .background(Color("ButtonColor"))
                    .cornerRadius(26)
                    .padding(50)
                    .shadow(color: Color.gray.opacity(0.5), radius: 8)
                
            }
        }
    }
}
*/

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView(showModal: .constant(false), content: Text("Content"))
    }
}
