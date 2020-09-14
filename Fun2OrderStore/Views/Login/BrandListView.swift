//
//  BrandListView.swift
//  Fun2Order_Store
//
//  Created by Lo Fang Chou on 2020/9/2.
//  Copyright © 2020 JStudio. All rights reserved.
//

import SwiftUI
import Firebase

struct BrandListView: View {
    @Binding var showFlag: Bool
    @Binding var brandStoreData: SelectedBrandStoreData
    
    //var tmpBrandName: [String] = ["上宇林", "Teas原味"]
    @State var brandNameList: [String] = [String]()
    @State var storeNameList: [String] = [String]()
    @State var showStore: Bool = false
    
    var body: some View {
        NavigationView {
            List(brandNameList, id: \.self) { brandName in
                VStack {
                    NavigationLink(destination: StoreListView(showFlag: self.$showFlag, brandStoreData: self.$brandStoreData, brandName: brandName)) {
                        HStack {
                            Spacer()
                            Text(brandName)
                                .font(.title)
                            Spacer()
                        }
                    }
                }
            }.navigationBarTitle("品牌列表", displayMode: .inline)
        }
        .onAppear() {
            self.queryCoworkBrandList()
        }
    }
    
    func queryCoworkBrandList() {
        let databaseRef = Database.database().reference()
        let pathString = "BRAND_CATEGORY"

        let query = (databaseRef.child(pathString).queryOrdered(byChild: "coworkBrandFlag")).queryEqual(toValue: true)
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                guard let brandList = snapshot.value as? [String: Any] else {
                    return
                }
                
                brandNameList.removeAll()
                for brandData in brandList {
                    print("brandData.key = \(brandData.key)")
                    brandNameList.append(brandData.key)
                }
            } else {
                print("queryCoworkBrandList snapshot doesn't exist!")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func queryBrandStoreList(brand_name: String) {
        downloadFBBrandStoreList(brand_name: brand_name, completion: { storeList in
            print("brand_name = [\(brand_name)]")
            if storeList == nil {
                print("storeList is nil")
                return
            }
            
            storeNameList.removeAll()
            for storeData in storeList! {
                storeNameList.append(storeData.storeName)
            }
            print("storeNameList = \(storeNameList)")
            self.showStore = true
        })
    }
}

//struct BrandListView_Previews: PreviewProvider {
    
//    static var previews: some View {
//        BrandListView(showFlag: .constant(true), brandStoreData: )
//    }
//}
