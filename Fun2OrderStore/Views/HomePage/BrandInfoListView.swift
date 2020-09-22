//
//  BrandInfoListView.swift
//  Fun2OrderStore
//
//  Created by Lo Fang Chou on 2020/9/7.
//

import SwiftUI

struct BrandInfoListView: View {
    var brandMessage: BrandMessage
    @State private var showDetailFlag: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading) {
                    Text(brandMessage.publishTime)
                        .foregroundColor(Color.white)

                    Text(brandMessage.messageTitle)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)

                    Text(brandMessage.messageSubTitle)
                        .foregroundColor(Color.white)

                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, alignment: .leading)
                .padding(5)
                .background(BACKGROUND_COLOR_GREEN)
                .cornerRadius(10)
                
                if showDetailFlag {
                    Text(brandMessage.messageDetail)
                        .foregroundColor(Color.black)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, alignment: .leading)
                        .padding(5)
                        .background(BACKGROUND_COLOR_LIGHTORANGE)
                        .cornerRadius(10)
                }
            }
        }
        .background(BACKGROUND_COLOR_GREEN)
        .cornerRadius(5)
        .overlay (
            RoundedRectangle(cornerRadius: 5)
                .stroke(BACKGROUND_COLOR_GREEN, lineWidth: 1.5)
        )
        .padding(5)
        .onTapGesture {
            print("Click BrandInfoListView")
            self.showDetailFlag = !self.showDetailFlag
        }
    }
}

//struct BrandInfoListView_Previews: PreviewProvider {
//    static var previews: some View {
//        BrandInfoListView(brandInfo: brandInfoList[0])
//    }
//}
