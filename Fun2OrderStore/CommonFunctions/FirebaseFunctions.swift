//
//  FirebaseFunctions.swift
//  Fun2Order
//
//  Created by Lo Fang Chou on 2020/1/27.
//  Copyright © 2020 JStudio. All rights reserved.
//

import Foundation
import Firebase

func uploadUserProfileTokenID(user_id: String, token_id: String) {
    let databaseRef = Database.database().reference()
    if Auth.auth().currentUser?.uid == nil {
        print("uploadUserProfileTokenID Auth.auth().currentUser?.uid == nil ")
        return
    }
    
    let pathString = "USER_PROFILE/\(Auth.auth().currentUser!.uid)/tokenID"
    databaseRef.child(pathString).setValue(token_id)

    let pathOSTypeString = "USER_PROFILE/\(Auth.auth().currentUser!.uid)/ostype"
    databaseRef.child(pathOSTypeString).setValue("iOS")
}

func deleteFBMenuInformation(menu_info: MenuInformation) {
    let databaseRef = Database.database().reference()
    if Auth.auth().currentUser?.uid == nil || menu_info.menuNumber == "" {
        print("deleteFBMenuInformation Auth.auth().currentUser?.uid == nil || menu_info.menuNumber is empty")
        return
    }
    
    let pathString = "USER_MENU_INFORMATION/\(Auth.auth().currentUser!.uid)/\(menu_info.menuNumber)"
    databaseRef.child(pathString).removeValue()
    
    if menu_info.menuImageURL != "" {
        let storageRef = Storage.storage().reference()
        let storagePath = menu_info.menuImageURL
        storageRef.child(storagePath).delete(completion: nil)
    }
    
    if menu_info.multiMenuImageURL != nil {
        let dispatchGroup = DispatchGroup()

        for i in 0...menu_info.multiMenuImageURL!.count - 1 {
            let newPath = menu_info.multiMenuImageURL![i]
            let newRef = Storage.storage().reference()
            
            dispatchGroup.enter()
            newRef.child(newPath).delete(completion: {(error) in
                if error == nil {
                    dispatchGroup.leave()
                } else {
                    print("Menu Image delete error: \(error!.localizedDescription)")
                    dispatchGroup.leave()
                }
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            let folderPath = "Menu_Image/\(Auth.auth().currentUser!.uid)/\(menu_info.menuNumber)"
            let storageRef = Storage.storage().reference()
            storageRef.child(folderPath).delete(completion: nil)
        }
    }
}

func deleteFBMenuOrderInformation(user_id: String, order_number: String) {
    let databaseRef = Database.database().reference()
    if Auth.auth().currentUser?.uid == nil || order_number == "" {
        print("deleteFBMenuOrderInformation Auth.auth().currentUser?.uid == nil || order_number is empty")
        return
    }
    let pathString = "USER_MENU_ORDER/\(Auth.auth().currentUser!.uid)/\(order_number)"
    databaseRef.child(pathString).removeValue()
}

func downloadFBMenuInformation(user_id: String, menu_number: String, completion: @escaping(MenuInformation?) -> Void) {
    var menuData: MenuInformation = MenuInformation()

    let databaseRef = Database.database().reference()
    
    let pathString = "USER_MENU_INFORMATION/\(user_id)/\(menu_number)"
    
    databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.exists() {
            let menuInfo = snapshot.value
            let jsonData = try? JSONSerialization.data(withJSONObject: menuInfo as Any, options: [])
            //let jsonString = String(data: jsonData!, encoding: .utf8)!
            //print("jsonString = \(jsonString)")

            let decoder: JSONDecoder = JSONDecoder()
            do {
                menuData = try decoder.decode(MenuInformation.self, from: jsonData!)
                //print("menuData decoded successful !!")
                //print("menuData = \(menuData)")
                completion(menuData)
            } catch {
                print("attendGroupOrder menuData jsonData decode failed: \(error.localizedDescription)")
                presentSimpleAlertMessage(title: "資料錯誤", message: "菜單資料讀取錯誤，請團購發起人重發。")
                completion(nil)
            }
        } else {
            print("attendGroupOrder USER_MENU_INFORMATION snapshot doesn't exist!")
            presentSimpleAlertMessage(title: "資料錯誤", message: "菜單資料不存在，請詢問團購發起人相關訊息。")
            completion(nil)
        }
    }) { (error) in
        print(error.localizedDescription)
        presentSimpleAlertMessage(title: "錯誤訊息", message: error.localizedDescription)
        completion(nil)
    }
}


func downloadFBMultiMenuImages(images_url: [String], completion: @escaping([UIImage]?) -> Void) {
    var returnImages: [UIImage]?
    var returnIndex: [Int] = [Int]()
    let dispatchGroup: DispatchGroup = DispatchGroup()
    
    if images_url.isEmpty {
        completion(nil)
    }
    
    for i in 0...images_url.count - 1 {
        if images_url[i] != "" {
            dispatchGroup.enter()
            let storageRef = Storage.storage().reference()
            storageRef.child(images_url[i]).getData(maxSize: 3 * 2048 * 2048, completion: { (data, error) in
                if let error = error {
                    presentSimpleAlertMessage(title: "存取影像錯誤", message: error.localizedDescription)
                    dispatchGroup.leave()
                    return
                }
                
                if data != nil {
                    if let imageData = UIImage(data: data!) {
                        if returnImages == nil {
                            returnImages = [UIImage]()
                        }
                        returnIndex.append(i)
                        returnImages!.append(imageData)
                    }
                    
                    dispatchGroup.leave()
                } else {
                    dispatchGroup.leave()
                }
            })
        }
    }
    
    dispatchGroup.notify(queue: .main) {
        print("returnIndex = \(returnIndex)")
        if returnImages != nil {
            //self.menuInfos.sort(by: {$0.createTime > $1.createTime})
            if returnImages!.count == returnIndex.count {
                let combinedArray = zip(returnIndex, returnImages!).sorted(by: { $0.0 < $1.0})
                print("Sorted index array = \(combinedArray.map { $0.0 })")
                returnImages = combinedArray.map { $0.1 }
            }
        }
        completion(returnImages)
    }
}

func downloadFBMenuImage(menu_url: String, completion: @escaping(UIImage?) -> Void) {
    var alertWindow: UIWindow!
    if menu_url != "" {
        let storageRef = Storage.storage().reference()
        storageRef.child(menu_url).getData(maxSize: 3 * 2048 * 2048, completion: { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                let controller = UIAlertController(title: "存取菜單影像錯誤", message: error.localizedDescription, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                    alertWindow.isHidden = true
                }
                
                controller.addAction(okAction)
                alertWindow = presentAlert(controller)
                completion(nil)
                return
            }
            
            completion(UIImage(data: data!)!)
        })
    }
}

func downloadFBMemberImage(member_id: String, completion: @escaping (UIImage?) -> Void) {
    var alertWindow: UIWindow!
    
    let databaseRef = Database.database().reference()
    let storageRef = Storage.storage().reference()
    
    let pathString = "USER_PROFILE/\(member_id)/photoURL"
    databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.exists() {
            let imageURL = snapshot.value as! String
            storageRef.child(imageURL).getData(maxSize: 3 * 2048 * 2048, completion: { (data, error) in
                if let error = error {
                    print(error.localizedDescription)
                    let controller = UIAlertController(title: "存取會員影像錯誤", message: error.localizedDescription, preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                        alertWindow.isHidden = true
                    }
                    
                    controller.addAction(okAction)
                    alertWindow = presentAlert(controller)
                    completion(nil)
                    return
                }
                
                completion(UIImage(data: data!)!)
            })
        } else {
            print("downloadMemberImage photoURL snapshot doesn't exist!")
            completion(nil)
        }
    })  { (error) in
        print(error.localizedDescription)
        completion(nil)
    }

}

func downloadFBBrandImage(brand_url: String, completion: @escaping(UIImage?) -> Void) {
    var alertWindow: UIWindow!
    if brand_url != "" {
        let storageRef = Storage.storage().reference()
        storageRef.child(brand_url).getData(maxSize: 3 * 1024 * 100, completion: { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                let controller = UIAlertController(title: "存取品牌影像錯誤", message: error.localizedDescription, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                    alertWindow.isHidden = true
                }
                
                controller.addAction(okAction)
                alertWindow = presentAlert(controller)
                completion(nil)
                return
            }
            
            completion(UIImage(data: data!)!)
        })
    }
}

func downloadFBUserProfile(user_id: String, completion: @escaping (UserProfile?) -> Void) {
    var userData: UserProfile = UserProfile()
    let databaseRef = Database.database().reference()
    let pathString = "USER_PROFILE/\(user_id)"

    databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.exists() {
            let userProfile = snapshot.value
            let jsonData = try? JSONSerialization.data(withJSONObject: userProfile as Any, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)!
            print("userProfile jsonString = \(jsonString)")

            let decoder: JSONDecoder = JSONDecoder()
            do {
                userData = try decoder.decode(UserProfile.self, from: jsonData!)
                print("userData decoded successful !!")
                print("userData = \(userData)")
                completion(userData)
            } catch {
                print("downloadFBUserProfile userData jsonData decode failed: \(error.localizedDescription)")
                completion(nil)
            }
        } else {
            print("downloadFBUserProfile USER_PROFILE snapshot doesn't exist!")
            completion(nil)
        }
    })  { (error) in
        print("downloadFBUserProfile Firebase error = \(error.localizedDescription)")
        completion(nil)
    }
}

func uploadFBUserProfile(user_profile: UserProfile) {
    let databaseRef = Database.database().reference()
    if Auth.auth().currentUser?.uid == nil {
        print("uploadFBUserProfile Auth.auth().currentUser?.uid == nil ")
        return
    }

    let pathString = "USER_PROFILE/\(Auth.auth().currentUser!.uid)"
    
    databaseRef.child(pathString).setValue(user_profile.toAnyObject())
}

func uploadFBMenuOrderContentItem(item: MenuOrderMemberContent, completion: @escaping () -> Void) {
    let databaseRef = Database.database().reference()

    if item.orderOwnerID == "" {
        print("uploadFBMenuOrderContentItem item.orderOwnerID is empty")
        return
    }
    
    let pathString = "USER_MENU_ORDER/\(item.orderOwnerID)/\(item.orderContent.orderNumber)/contentItems"
    //print("uploadFBMenuOrderContentItem pathString = \(pathString)")
    databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.exists() {
            let itemRawData = snapshot.value
            let jsonData = try? JSONSerialization.data(withJSONObject: itemRawData as Any, options: [])

            let decoder: JSONDecoder = JSONDecoder()
            do {
                let itemArray = try decoder.decode([MenuOrderMemberContent].self, from: jsonData!)

                if let itemIndex = itemArray.firstIndex(where: { $0.memberID == item.memberID }) {
                    //print("itemData = \(itemArray[itemIndex])")
                    //print("itemIndex = \(itemIndex)")
                    let uploadPathString = pathString + "/\(itemIndex)"
                    databaseRef.child(uploadPathString).setValue(item.toAnyObject()) { (error, reference) in
                        if error != nil {
                            presentSimpleAlertMessage(title: "資料更新錯誤", message: error!.localizedDescription)
                            return
                        }
                        completion()
                    }
                }
            } catch {
                print("uploadFBMenuOrderContentItem jsonData decode failed: \(error.localizedDescription)")
            }
        } else {
            print("uploadFBMenuOrderContentItem snapshot doesn't exist!")
            return
        }
    }) { (error) in
        print(error.localizedDescription)
    }
}

func uploadFBMenuRecipeTemplate(user_id: String, template: MenuRecipeTemplate) {
    if user_id == "" || template.templateName == "" {
        print("uploadFBMenuRecipeTemplate user_id is empty || template.templateName is empty")
        return
    }
    
    let databaseRef = Database.database().reference()
    let pathString = "USER_CUSTOM_RECIPE_TEMPLATE/\(user_id)/\(template.templateName)"
    
    databaseRef.child(pathString).setValue(template.toAnyObject())
}


func downloadFBDetailBrandProfile(brand_name: String, completion: @escaping (DetailBrandProfile?) -> Void) {
    var brandData: DetailBrandProfile = DetailBrandProfile()
    let databaseRef = Database.database().reference()
    let pathString = "DETAIL_BRAND_PROFILE/\(brand_name)"

    databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.exists() {
            let brandProfile = snapshot.value
            let jsonData = try? JSONSerialization.data(withJSONObject: brandProfile as Any, options: [])
            //let jsonString = String(data: jsonData!, encoding: .utf8)!
            //print("brandProfile jsonString = \(jsonString)")

            let decoder: JSONDecoder = JSONDecoder()
            do {
                brandData = try decoder.decode(DetailBrandProfile.self, from: jsonData!)
                print("brandData decoded successful !!")
                print("brandData = \(brandData)")
                completion(brandData)
            } catch {
                print("downloadFBDetailBrandProfile brandData jsonData decode failed: \(error.localizedDescription)")
                completion(nil)
            }
        } else {
            print("downloadFBDetailBrandProfile DETAIL_BRAND_PROFILE snapshot doesn't exist!")
            completion(nil)
        }
    })  { (error) in
        print("downloadFBDetailBrandProfile Firebase error = \(error.localizedDescription)")
        completion(nil)
    }
}

func downloadFBDetailMenuInformation(menu_number: String, completion: @escaping (DetailMenuInformation?) -> Void) {
    var menuData: DetailMenuInformation = DetailMenuInformation()
    let databaseRef = Database.database().reference()
    let pathString = "DETAIL_MENU_INFORMATION/\(menu_number)"

    databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.exists() {
            let menuInfo = snapshot.value
            let jsonData = try? JSONSerialization.data(withJSONObject: menuInfo as Any, options: [])
            //let jsonString = String(data: jsonData!, encoding: .utf8)!
            //print("menuInfo jsonString = \(jsonString)")

            let decoder: JSONDecoder = JSONDecoder()
            do {
                menuData = try decoder.decode(DetailMenuInformation.self, from: jsonData!)
                print("menuData decoded successful !!")
                print("menuData = \(menuData)")
                completion(menuData)
            } catch {
                print("downloadFBDetailMenuInformation menuData jsonData decode failed: \(error.localizedDescription)")
                completion(nil)
            }
        } else {
            print("downloadFBDetailMenuInformation DETAIL_MENU_INFORMATION snapshot doesn't exist!")
            completion(nil)
        }
    })  { (error) in
        print("downloadFBDetailMenuInformation Firebase error = \(error.localizedDescription)")
        completion(nil)
    }
}

func uploadFBBrandCategory(brand_name: String, brand_category: DetailBrandCategory) {
    
    let databaseRef = Database.database().reference()
    let pathString = "BRAND_CATEGORY/\(brand_name)"
    
    databaseRef.child(pathString).setValue(brand_category.toAnyObject())
}

func uploadFBDetailBrandProfile(brand_name: String, brand_profile: DetailBrandProfile) {
    
    let databaseRef = Database.database().reference()
    let pathString = "DETAIL_BRAND_PROFILE/\(brand_name)"
    
    databaseRef.child(pathString).setValue(brand_profile.toAnyObject())
}

func monitorFBProductQuantityLimit(owner_id: String, order_number: String, completion: @escaping([MenuItem]?) -> Void) {
    let databaseRef = Database.database().reference()
    let pathString = "USER_MENU_ORDER/\(owner_id)/\(order_number)/limitedMenuItems"

    //databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
    databaseRef.child(pathString).observe(.value, with: { (snapshot) in
        if snapshot.exists() {
            var menuItems: [MenuItem] = [MenuItem]()
            let childEnumerator = snapshot.children
            
            let childDecoder: JSONDecoder = JSONDecoder()
            while let childData = childEnumerator.nextObject() as? DataSnapshot {
                //print("child = \(childData)")
                do {
                    let childJsonData = try? JSONSerialization.data(withJSONObject: childData.value as Any, options: [])
                    let realData = try childDecoder.decode(MenuItem.self, from: childJsonData!)
                    menuItems.append(realData)
                    print("Success: \(realData.itemName)")
                } catch {
                    print("monitorFBProductQuantityLimit jsonData decode failed: \(error.localizedDescription)")
                    continue
                }
            }

            if menuItems.isEmpty {
                completion(nil)
            } else {
                completion(menuItems)
            }
        } else {
            print("monitorFBProductQuantityLimit [MenuItem] snapshot doesn't exist!")
            completion(nil)
        }
    })  { (error) in
        print("monitorFBProductQuantityLimit Firebase error = \(error.localizedDescription)")
        completion(nil)
    }
}

func downloadFBBrandEventList(brand_name: String, completion: @escaping([DetailBrandEvent]?) -> Void) {
    let databaseRef = Database.database().reference()
    let pathString = "DETAIL_BRAND_EVENT/\(brand_name)"

    //databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
    databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.exists() {
            var eventItems: [DetailBrandEvent] = [DetailBrandEvent]()
            let childEnumerator = snapshot.children
            
            let childDecoder: JSONDecoder = JSONDecoder()
            while let childData = childEnumerator.nextObject() as? DataSnapshot {
                //print("child = \(childData)")
                do {
                    let childJsonData = try? JSONSerialization.data(withJSONObject: childData.value as Any, options: [])
                    let realData = try childDecoder.decode(DetailBrandEvent.self, from: childJsonData!)
                    eventItems.append(realData)
                    //print("Success: \(realData.itemName)")
                } catch {
                    print("downloadFBBrandEventList jsonData decode failed: \(error.localizedDescription)")
                    continue
                }
            }

            if eventItems.isEmpty {
                completion(nil)
            } else {
                completion(eventItems)
            }
        } else {
            print("downloadFBBrandEventList [DetailBrandEvent] snapshot doesn't exist!")
            completion(nil)
        }
    })  { (error) in
        print("downloadFBBrandEventList Firebase error = \(error.localizedDescription)")
        completion(nil)
    }
}

func downloadFBDetailStoreInformation(brand_name: String, store_name: String, completion: @escaping(DetailStoreInformation?) -> Void) {
    var storeData: DetailStoreInformation = DetailStoreInformation()
    let databaseRef = Database.database().reference()
    let pathString = "DETAIL_BRAND_STORE/\(brand_name)/\(store_name)"

    databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.exists() {
            let storeInfo = snapshot.value
            let jsonData = try? JSONSerialization.data(withJSONObject: storeInfo as Any, options: [])
            //let jsonString = String(data: jsonData!, encoding: .utf8)!
            //print("menuInfo jsonString = \(jsonString)")

            let decoder: JSONDecoder = JSONDecoder()
            do {
                storeData = try decoder.decode(DetailStoreInformation.self, from: jsonData!)
                //print("menuData decoded successful !!")
                //print("menuData = \(menuData)")
                completion(storeData)
            } catch {
                print("downloadFBDetailStoreInformation storeData jsonData decode failed: \(error.localizedDescription)")
                completion(nil)
            }
        } else {
            print("downloadFBDetailStoreInformation DETAIL_BRAND_STORE snapshot doesn't exist!")
            completion(nil)
        }
    })  { (error) in
        print("downloadFBDetailStoreInformation Firebase error = \(error.localizedDescription)")
        completion(nil)
    }
}

func updateFBDetailStoreInformation(brand_name: String, store_info: DetailStoreInformation) {
    if brand_name == "" {
        print("Brand Name is blank, so rturns")
        return
    }
    
    if store_info.storeName == "" {
        print("Store Name is blank, so rturns")
        return
    }
    
    let databaseRef = Database.database().reference()
    let pathString = "DETAIL_BRAND_STORE/\(brand_name)/\(store_info.storeName)"

    databaseRef.child(pathString).setValue(store_info.toAnyObject())
}

func downloadFBBrandStoreList(brand_name: String, completion: @escaping([DetailStoreInformation]?) -> Void) {
    let databaseRef = Database.database().reference()
    let pathString = "DETAIL_BRAND_STORE/\(brand_name)"

    //databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
    databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.exists() {
            var storeItems: [DetailStoreInformation] = [DetailStoreInformation]()
            let childEnumerator = snapshot.children
            
            let childDecoder: JSONDecoder = JSONDecoder()
            while let childData = childEnumerator.nextObject() as? DataSnapshot {
                //print("child = \(childData)")
                do {
                    let childJsonData = try? JSONSerialization.data(withJSONObject: childData.value as Any, options: [])
                    let realData = try childDecoder.decode(DetailStoreInformation.self, from: childJsonData!)
                    storeItems.append(realData)
                    //print("Success: \(realData.itemName)")
                } catch {
                    print("downloadFBBrandStoreList jsonData decode failed: \(error.localizedDescription)")
                    continue
                }
            }

            if storeItems.isEmpty {
                completion(nil)
            } else {
                completion(storeItems)
            }
        } else {
            print("downloadFBBrandStoreList [DetailStoreInformation] snapshot doesn't exist!")
            completion(nil)
        }
    })  { (error) in
        print("downloadFBBrandStoreList Firebase error = \(error.localizedDescription)")
        completion(nil)
    }
}

func downloadFBBrandStoreInfo(brand_name: String, store_name: String, completion: @escaping(DetailStoreInformation?) -> Void) {
    let databaseRef = Database.database().reference()
    let pathString = "DETAIL_BRAND_STORE/\(brand_name)"

    databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.exists() {
            var storeItems: DetailStoreInformation? = nil
            let childEnumerator = snapshot.children
            
            let childDecoder: JSONDecoder = JSONDecoder()
            while let childData = childEnumerator.nextObject() as? DataSnapshot {
                //print("child = \(childData)")
                do {
                    let childJsonData = try? JSONSerialization.data(withJSONObject: childData.value as Any, options: [])
                    let realData = try childDecoder.decode(DetailStoreInformation.self, from: childJsonData!)
                    if realData.storeName == store_name
                    {
                        storeItems = realData
                    }
                } catch {
                    print("downloadFBBrandStoreList jsonData decode failed: \(error.localizedDescription)")
                    continue
                }
            }
            completion(storeItems)
        } else {
            print("downloadFBBrandStoreList [DetailStoreInformation] snapshot doesn't exist!")
            completion(nil)
        }
    })  { (error) in
        print("downloadFBBrandStoreList Firebase error = \(error.localizedDescription)")
        completion(nil)
    }
}

func downloadFBStoreUserControl(brand_name: String, user_id: String, completion: @escaping(StoreUserControl?) -> Void) {
    var userData: StoreUserControl = StoreUserControl()
    let databaseRef = Database.database().reference()
    let pathString = "STORE_USER_CONTROL/\(brand_name)/\(user_id)"

    //databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
    databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.exists() {
            let userInfo = snapshot.value
            let jsonData = try? JSONSerialization.data(withJSONObject: userInfo as Any, options: [])
            //let jsonString = String(data: jsonData!, encoding: .utf8)!
            //print("userInfo jsonString = \(jsonString)")

            let decoder: JSONDecoder = JSONDecoder()

            do {
                userData = try decoder.decode(StoreUserControl.self, from: jsonData!)
                //print("menuData decoded successful !!")
                //print("menuData = \(userData)")
                completion(userData)
            } catch {
                print("downloadFBStoreUserControl userData jsonData decode failed: \(error.localizedDescription)")
                completion(nil)
            }
        } else {
            print("downloadFBStoreUserControl StoreUserControl snapshot doesn't exist!")
            completion(nil)
        }
    })  { (error) in
        print("downloadFBStoreUserControl Firebase error = \(error.localizedDescription)")
        completion(nil)
    }
}

func downloadFBStoreUserControlList(brand_name: String, completion: @escaping([StoreUserControl]?) -> Void) {
    let databaseRef = Database.database().reference()
    let pathString = "STORE_USER_CONTROL/\(brand_name)"

    databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.exists() {
            var userList: [StoreUserControl] = [StoreUserControl]()
            let childEnumerator = snapshot.children
            
            let childDecoder: JSONDecoder = JSONDecoder()
            while let childData = childEnumerator.nextObject() as? DataSnapshot {
                //print("child = \(childData)")
                do {
                    let childJsonData = try? JSONSerialization.data(withJSONObject: childData.value as Any, options: [])
                    let realData = try childDecoder.decode(StoreUserControl.self, from: childJsonData!)
                    userList.append(realData)
                    //print("Success: \(realData.itemName)")
                } catch {
                    print("downloadFBStoreUserControlList jsonData decode failed: \(error.localizedDescription)")
                    continue
                }
            }

            if userList.isEmpty {
                completion(nil)
            } else {
                completion(userList)
            }
        } else {
            print("downloadFBStoreUserControlList [StoreUserControl] snapshot doesn't exist!")
            completion(nil)
        }
    })  { (error) in
        print("downloadFBStoreUserControlList Firebase error = \(error.localizedDescription)")
        completion(nil)
    }
}

func uploadFBBrandMessage(brand_name: String, brand_message: BrandMessage) {
    let databaseRef = Database.database().reference()
    if brand_name == "" {
        print("uploadFBBrandMessage brand_name is blank ")
        return
    }

    let pathString = "BRAND_MESSAGE/\(brand_name)/\(brand_message.publishTime)"
    
    databaseRef.child(pathString).setValue(brand_message.toAnyObject())
}

func downloadFBBrandMessageList(brand_name: String, completion: @escaping([BrandMessage]?) -> Void) {
    let databaseRef = Database.database().reference()
    let pathString = "BRAND_MESSAGE/\(brand_name)"

    //databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
    databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.exists() {
            var brandMessages: [BrandMessage] = [BrandMessage]()
            let childEnumerator = snapshot.children
            
            let childDecoder: JSONDecoder = JSONDecoder()
            while let childData = childEnumerator.nextObject() as? DataSnapshot {
                //print("child = \(childData)")
                do {
                    let childJsonData = try? JSONSerialization.data(withJSONObject: childData.value as Any, options: [])
                    let realData = try childDecoder.decode(BrandMessage.self, from: childJsonData!)
                    brandMessages.append(realData)
                    //print("Success: \(realData.itemName)")
                } catch {
                    print("downloadFBBrandMessageList jsonData decode failed: \(error.localizedDescription)")
                    continue
                }
            }

            if brandMessages.isEmpty {
                completion(nil)
            } else {
                let returnMessages = brandMessages.sorted(by:  { $0.publishTime > $1.publishTime })
                completion(returnMessages)
            }
        } else {
            print("downloadFBBrandMessageList [BrandMessage] snapshot doesn't exist!")
            completion(nil)
        }
    })  { (error) in
        print("downloadFBBrandMessageList Firebase error = \(error.localizedDescription)")
        completion(nil)
    }
}

func downloadFBStoreOrderList(brand_name: String, store_name: String, day_string: String, completion: @escaping([OrderSummaryData]?) -> Void) {
    let databaseRef = Database.database().reference()
    let pathString = "STORE_MENU_ORDER/\(brand_name)/\(store_name)/\(day_string)"

    databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.exists() {
            var summaryList: [OrderSummaryData] = [OrderSummaryData]()
            let childEnumerator = snapshot.children
            
            let childDecoder: JSONDecoder = JSONDecoder()
            while let childData = childEnumerator.nextObject() as? DataSnapshot {
                //print("child = \(childData)")
                do {
                    let childJsonData = try? JSONSerialization.data(withJSONObject: childData.value as Any, options: [])
                    let realData = try childDecoder.decode(MenuOrder.self, from: childJsonData!)
                    let summaryData = convertMenuOrderToOrderSummary(menu_order: realData)
                    summaryList.append(summaryData)
                    //print("Success: \(realData.itemName)")
                } catch {
                    print("downloadFBStoreOrderList jsonData decode failed: \(error.localizedDescription)")
                    continue
                }
            }

            if summaryList.isEmpty {
                completion(nil)
            } else {
                completion(summaryList)
            }
        } else {
            print("downloadFBStoreOrderList [MenuOrder] snapshot doesn't exist!")
            completion(nil)
        }
    })  { (error) in
        print("downloadFBBrandMessageList Firebase error = \(error.localizedDescription)")
        completion(nil)
    }
}

func updateFBOrderStatus(user_auth: UserAuth, order_data: OrderSummaryData, day_string: String) {
    let databaseRef = Database.database().reference()
    let pathString = "STORE_MENU_ORDER/\(user_auth.userControl.brandName)/\(user_auth.userControl.storeName)/\(day_string)/\(order_data.orderNumber)"
    
    let statusPath = pathString + "/orderStatus"
    databaseRef.child(statusPath).setValue(order_data.orderStatus)
    
    var historyRecord: OrderHistoryRecord = OrderHistoryRecord()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss_SSS"
    let timeStampString = formatter.string(from: Date())
    
    historyRecord.claimTimeStamp = timeStampString
    historyRecord.claimUser = user_auth.userControl.userName
    historyRecord.claimStatus = order_data.orderStatus
    
    let historyPath = pathString + "/orderHistory/\(timeStampString)"
    databaseRef.child(historyPath).setValue(historyRecord.toAnyObject())
    
}

func downloadFBStoreInformation(brand_name: String, store_name: String, completion: @escaping (DetailStoreInformation?) -> Void) {
    var storeData: DetailStoreInformation = DetailStoreInformation()
    let databaseRef = Database.database().reference()
    let pathString = "DETAIL_BRAND_STORE/\(brand_name)/\(store_name)"

    databaseRef.child(pathString).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.exists() {
            let storeInfo = snapshot.value
            let jsonData = try? JSONSerialization.data(withJSONObject: storeInfo as Any, options: [])
            //let jsonString = String(data: jsonData!, encoding: .utf8)!
            //print("brandProfile jsonString = \(jsonString)")

            let decoder: JSONDecoder = JSONDecoder()
            do {
                storeData = try decoder.decode(DetailStoreInformation.self, from: jsonData!)
                //print("storeData decoded successful !!")
                //print("storeData = \(brandData)")
                completion(storeData)
            } catch {
                print("downloadFBStoreInformation storeData jsonData decode failed: \(error.localizedDescription)")
                completion(nil)
            }
        } else {
            print("downloadFBStoreInformation DETAIL_BRAND_STORE snapshot doesn't exist!")
            completion(nil)
        }
    })  { (error) in
        print("downloadFBStoreInformation Firebase error = \(error.localizedDescription)")
        completion(nil)
    }
}

func updateFBStoreInformation(user_auth: UserAuth, store_info: DetailStoreInformation) {
    let databaseRef = Database.database().reference()
    let pathString = "DETAIL_BRAND_STORE/\(user_auth.userControl.brandName)/\(user_auth.userControl.storeName)"
    
    databaseRef.child(pathString).setValue(store_info.toAnyObject())
}

func updateFBLoginPassword(user_auth: UserAuth, new_password: String) {
    Auth.auth().currentUser?.updatePassword(to: new_password, completion: { error in
        if error == nil {
            let databaseRef = Database.database().reference()
            let pathString = "STORE_USER_CONTROL/\(user_auth.userControl.brandName)/\(user_auth.userControl.userID)/userPassword"
            
            databaseRef.child(pathString).setValue(new_password)
        } else {
            presentSimpleAlertMessage(title: "錯誤訊息", message: error!.localizedDescription)
        }
    })
}

func updateFBBrandEvent(user_auth: UserAuth, event_data: DetailBrandEvent) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dayString = formatter.string(from: Date())
    
    let databaseRef = Database.database().reference()
    let pathString = "DETAIL_BRAND_EVENT/\(user_auth.userControl.brandName)/\(dayString)"
    
    databaseRef.child(pathString).setValue(event_data.toAnyObject())
}

func updateFBStoreBusinessTime(user_auth: UserAuth, change_date: Date, business_time: BusinessTime) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dayString = formatter.string(from: change_date)
    
    let databaseRef = Database.database().reference()
    let pathString = "STORE_BUSINESS_TIME_CHANGE/\(user_auth.userControl.brandName)/\(user_auth.userControl.storeName)/\(dayString)"
    
    databaseRef.child(pathString).setValue(business_time.toAnyObject())
}

func updateFBMyTokenID(user_auth: UserAuth) {
    InstanceID.instanceID().instanceID { (result, error) in
        if let error = error {
            print("updateFBMyTokenID -> Error fetching remote instance ID: \(error)")
            return
        } else if let result = result {
            print("updateFBMyTokenID -> Remote instance ID token: \(result.token)")
            
            if user_auth.userControl.brandName == "" || user_auth.userControl.userID == "" {
                print("updateFBMyTokenID brandName or userID is blank")
                return
            }
            
            let databaseRef = Database.database().reference()
            let pathString = "STORE_USER_CONTROL/\(user_auth.userControl.brandName)/\(user_auth.userControl.userID)"
            
            user_auth.userControl.userToken = result.token
            
            databaseRef.child(pathString).setValue(user_auth.userControl.toAnyObject())
        }
    }


}

//------------ ABY Chris 20200921 --------
func downloadFBMenuShortageItem( brandName: String, storeName:String, completion: @escaping ([ShortageItem]?) -> Void) {
    let databaseRef = Database.database().reference()
    let formatter = DateFormatter()
    formatter.dateFormat = DATETIME_FORMATTER_DATE
    let dateStamp = formatter.string(from: Date())
    let downloadPathString = "DETAIL_BRAND_STORE_SHORTAGE/\(brandName)/\(storeName)/\(dateStamp)"
    
    databaseRef.child(downloadPathString).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.exists() {
            let shortageInfo = snapshot.value
            let jsonData = try? JSONSerialization.data(withJSONObject: shortageInfo as Any, options: [])
            let decoder: JSONDecoder = JSONDecoder()
            
            
            if let JSONString = String(data: jsonData!, encoding: String.Encoding.utf8) {
               print(JSONString)
            }
            
            do {
                
                let shortageInfo = try decoder.decode([ShortageItem].self, from: jsonData!)
                completion(shortageInfo)
                
            } catch {
                print("downloadFBMenuShortageItem shortageData jsonData decode failed: \(error.localizedDescription)")
                completion(nil)
            }
        } else {
            print("downloadFBMenuShortageItem DETAIL_BRAND_STORE_SHORTAGE snapshot doesn't exist!")
            completion(nil)
        }
    })  { (error) in
        print("downloadFBMenuShortageItem Firebase error = \(error.localizedDescription)")
        completion(nil)
    }
    
}

//------------ ABY Chris 20200921 --------
func uploadFBMenuShortageItem(shortageInfo: [ShortageItem], brandName: String, storeName:String, completion: @escaping () -> Void) {
    let databaseRef = Database.database().reference()

    
    if brandName == "" || storeName == "" {
        print("uploadFBMenuShortageItem brandName or storeName is null")
        return
    }
    
    let formatter = DateFormatter()
    formatter.dateFormat = DATETIME_FORMATTER_DATE
    let dateStamp = formatter.string(from: Date())
    let uploadPathString = "DETAIL_BRAND_STORE_SHORTAGE/\(brandName)/\(storeName)/\(dateStamp)"
    
    //----- Assembly Json File format -----
    var shortageItemsArray: [Any] = [Any]()
    for itemData in (shortageInfo as [ShortageItem]?)! {
        shortageItemsArray.append(itemData.toAnyObject())
    }
    
    databaseRef.child(uploadPathString).setValue(shortageItemsArray) { (error, reference) in
        if error != nil {
            presentSimpleAlertMessage(title: "資料上傳錯誤", message: error!.localizedDescription)
            return
        }
        completion()
    }
}

func updateFBUserMenuOrderStatus(user_id: String, order_number: String, status_code: String) {
    if user_id.trimmingCharacters(in: .whitespacesAndNewlines) == "" || order_number.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        presentSimpleAlertMessage(title: "錯誤訊息", message: "使用者ID/訂單號碼 資料中存在空白")
        return
    }
    
    let databaseRef = Database.database().reference()
    let pathString = "USER_MENU_ORDER/\(user_id)/\(order_number)/orderStatus"
    
    databaseRef.child(pathString).setValue(status_code)
}
