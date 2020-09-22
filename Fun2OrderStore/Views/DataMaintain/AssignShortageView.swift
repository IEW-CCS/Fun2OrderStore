//
//  AssignShortageView.swift
//  Fun2OrderStore
//
//  Created by Lo Fang Chou on 2020/9/7.
//

import SwiftUI
import Firebase

struct AssignShortageView: View {
    
    @State  private var selectedProduct: String = ""
    @State  private var productItems: [String:[activityShortageItem]] = [String:[activityShortageItem]]()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userAuth: UserAuth
   
    var body: some View {
        //ScrollView {
            VStack {
                Text("請勾選目前缺貨之產品").font(.title)
                
                HStack{
                    Picker(selection: $selectedProduct, label: Text("")) {
                        ForEach(productItems.keys.sorted(), id: \.self) { key in
                            Text(key)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(SegmentedPickerStyle())
                }
            
                Spacer()
                
                Form {
                    if let items = productItems[selectedProduct] {
                        ForEach(0 ..< items.count , id:\.self) { index in
                            HStack {
                                Text((items[index].product)).padding()
                                Spacer()
                                Toggle("", isOn: self.binding(Section: selectedProduct, index: index))
                            }
                        }
                    }
                }

                Button(action: {self.updateShortageItem()}) {
                    Text("確定")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 180, height: 40)
                        .background(BACKGROUND_COLOR_GREEN)
                        .cornerRadius(10.0)
                }
            }
            .padding()
            .onAppear(){
                print("NavigationView onAppear with assign Shortage")
                downloadProductItem(brandName : userAuth.userControl.brandName , storeName : userAuth.userControl.storeName)
            }
        //}
    }
    
    
    private func binding( Section: String, index : Int) -> Binding<Bool> {
            return .init(
                get: { self.productItems[Section]![index].isShortage  },
                set: { self.productItems[Section]![index].isShortage = $0 })
   }
    
    
    func downloadProductItem(brandName : String, storeName : String) {
        downloadFBBrandStoreInfo(brand_name: brandName, store_name: storeName,   completion: { storeInfo in
            if storeInfo == nil {
                print("storeInfo is nil")
                presentSimpleAlertMessage(title: "錯誤訊息", message: "品牌資料下載錯誤")
                return
            }
            
            let dispatchGroup = DispatchGroup()
            
            var shortageInfo:[ShortageItem]? = nil
            dispatchGroup.enter()
            downloadFBMenuShortageItem( brandName: brandName, storeName:storeName, completion: { tmpShortageInfo in
                shortageInfo = tmpShortageInfo
                dispatchGroup.leave()
            })
            
            var detailMenuInfo: DetailMenuInformation? = nil
            dispatchGroup.enter()
            downloadFBDetailMenuInformation(menu_number: storeInfo!.storeMenuNumber, completion: { tmpDetailMenuInfo in
                detailMenuInfo = tmpDetailMenuInfo
                dispatchGroup.leave()
            })
                
            
            dispatchGroup.notify(queue: .main) {
                if detailMenuInfo == nil {
                    print("detailMenuInfo is nil")
                    presentSimpleAlertMessage(title: "錯誤訊息", message: "產品資料下載錯誤")
                    return
                }
                
                if detailMenuInfo?.productCategory == nil {
                    print("self.detailMenuInfo.productCategory is nil")
                    presentSimpleAlertMessage(title: "錯誤訊息", message: "菜單並無任何產品資訊")
                    return
                }
                
                detailMenuInfo?.productCategory?.forEach{(category) in
                    
                    let CatetoryName = category.categoryName
                    var CategoryItem = [activityShortageItem]()
                    
                    category.productItems?.forEach({ (DetailProductItem) in
                        let isShortage = shortageInfo?.contains(where: { $0.itemProduct == DetailProductItem.productName }) ?? false
                        CategoryItem.append(activityShortageItem( category: DetailProductItem.productCategory!, product: DetailProductItem.productName,  isShortage: isShortage))
                    })
                    productItems.updateValue(CategoryItem, forKey: CatetoryName)
                }
                selectedProduct = productItems.keys.sorted().first ?? ""
            }
        })
    }

    func updateShortageItem() {
        
        var shortageProductItemList: [activityShortageItem] = [activityShortageItem]()
        productItems.forEach { key, value in
            let shortageItems  = value.lazy.filter{ item in item.isShortage == true}
            shortageProductItemList += shortageItems
        }
        
        //------ FB Shortage Items List -------
        var ShortageItemList: [ShortageItem] = [ShortageItem]()
        shortageProductItemList.enumerated().forEach { (index,item)in
            ShortageItemList.append(ShortageItem(sequenceNumber: index, category: item.category, product: item.product))
        }
        
        //------ Upload to Firebase ----------
        uploadFBMenuShortageItem(shortageInfo: ShortageItemList, brandName: userAuth.userControl.brandName, storeName: userAuth.userControl.storeName, completion: {})

        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AssignShortageView_Previews: PreviewProvider {
    static var previews: some View {
        AssignShortageView()
    }
}
