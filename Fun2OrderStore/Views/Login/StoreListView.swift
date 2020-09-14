//
//  StoreListView.swift
//  Fun2Order_Store
//
//  Created by Lo Fang Chou on 2020/9/2.
//  Copyright © 2020 JStudio. All rights reserved.
//

import SwiftUI

struct StoreListView: View {
    @Binding public var showFlag: Bool
    @Binding var brandStoreData: SelectedBrandStoreData
    @State var brandName: String = ""
    
    @State var storeName: [String] = [String]()
    @State var selectedName: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { self.cancelSelection() }) {
                    Text("取消")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 180, height: 40)
                        .background(BACKGROUND_COLOR_GREEN)
                        .cornerRadius(5.0)

                }

                Button(action: { self.confirmSelection() }) {
                    Text("確定")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 180, height: 40)
                        .background(BACKGROUND_COLOR_GREEN)
                        .cornerRadius(5.0)

                }.padding()
            }

            List(self.storeName, id: \.self) { storeName in
                HStack {
                    Spacer()
                    
                    Text(storeName)
                        .font(.title)
                    Spacer()
                }.background( self.selectedName == storeName ? Color.blue : Color.clear )
                
                .onTapGesture {
                    print("Selected Store Name = [\(storeName)]")
                    self.brandStoreData.brandName = self.brandName
                    self.brandStoreData.storeName = storeName
                    self.selectedName = storeName
                }
            }.padding()
            .listStyle(GroupedListStyle())
        }
        .onAppear() {
            print("StoreListView onAppear")
            self.queryBrandStoreList(brand_name: self.brandName)
        }
        
    }

    func queryBrandStoreList(brand_name: String) {
        downloadFBBrandStoreList(brand_name: brand_name, completion: { storeList in
            print("brand_name = [\(brand_name)]")
            if storeList == nil {
                print("storeList is nil")
                return
            }
            
            storeName.removeAll()
            for storeData in storeList! {
                storeName.append(storeData.storeName)
            }
            print("storeName = \(storeName)")
        })
    }

    func cancelSelection() {
        print("Click Cancel Button")
        
        self.showFlag = false
    }
    
    func confirmSelection() {
        print("Click Confirm Button")
        self.showFlag = false
    }
}

//struct StoreListView_Previews: PreviewProvider {
//    static var previews: some View {
//        StoreListView(showFlag: .constant(true), brandName: "上宇林", storeName: ["Test"])
//    }
//}
