//
//  UtilityFunctions.swift
//  Fun2Order_Store
//
//  Created by Lo Fang Chou on 2020/8/29.
//  Copyright © 2020 JStudio. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import MessageUI

class EmailHelper: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = EmailHelper()
    private override init() {
        //
    }
    
    func sendEmail(subject:String, body:String, to:String){
        if !MFMailComposeViewController.canSendMail() {
            //Utilities.showErrorBanner(title: "No mail account found", subtitle: "Please setup a mail account")
            presentSimpleAlertMessage(title: "錯誤訊息", message: "找不到電子郵件帳號，請先設定電子郵件帳號後再試一次")
            return
        }
        
        let picker = MFMailComposeViewController()
        
        picker.setSubject(subject)
        picker.setMessageBody(body, isHTML: true)
        picker.setToRecipients([to])
        picker.mailComposeDelegate = self
        
        EmailHelper.getRootViewController()?.present(picker, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        EmailHelper.getRootViewController()?.dismiss(animated: true, completion: nil)
    }
    
    static func getRootViewController() -> UIViewController? {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController
    }
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

extension Optional where Wrapped == String {
    var _bound: String? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var bound: String {
        get {
            return _bound ?? ""
        }
        set {
            _bound = newValue.isEmpty ? nil : newValue
        }
    }
}

func presentAlert(_ alertController: UIAlertController) -> UIWindow {
 
    // 創造一個 UIWindow 的實例。
    let alertWindow = UIWindow()
    
    if #available(iOS 13.0, *) {
        // 取得 view 所屬的 windowScene，並指派給 alertWindow。
        //guard let windowScene = alertController.view.window?.windowScene else { return }
        let windowScene = UIApplication.shared.connectedScenes.first { $0.activationState == .foregroundActive }
        alertWindow.windowScene = windowScene as? UIWindowScene
    }
 
    // UIWindow 預設的背景色是黑色，但我們想要 alertWindow 的背景是透明的。
    alertWindow.backgroundColor = nil
 
    // 將 alertWindow 的顯示層級提升到最上方，不讓它被其它視窗擋住。
    alertWindow.windowLevel = .alert
 
    // 指派一個空的 UIViewController 給 alertWindow 當 rootViewController。
    DispatchQueue.main.async {
       alertWindow.rootViewController = UIViewController()
    
       // 將 alertWindow 顯示出來。由於我們不需要使 alertWindow 變成主視窗，所以沒有必要用 alertWindow.makeKeyAndVisible()。
       alertWindow.isHidden = false
    
       // 使用 alertWindow 的 rootViewController 來呈現警告。
       alertWindow.rootViewController?.present(alertController, animated: true)
    }
    
    return alertWindow
}

func presentSimpleAlertMessage(title: String, message: String) {
    var alertWindow: UIWindow!
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
        alertWindow.isHidden = true
    }
    
    controller.addAction(okAction)
    alertWindow = presentAlert(controller)
}

func convertMenuOrderToOrderSummary(menu_order: MenuOrder) -> OrderSummaryData {
    var summaryData: OrderSummaryData = OrderSummaryData()
    var mergedContents: [MergedContent] = [MergedContent]()
    
    summaryData.orderStatus = menu_order.orderStatus
    summaryData.ownerUID = menu_order.orderOwnerID
    summaryData.orderNumber = menu_order.orderNumber
    summaryData.updateTime = menu_order.createTime
    summaryData.totalCount = menu_order.orderTotalQuantity
    summaryData.totalPrice = menu_order.orderTotalPrice

    if menu_order.deliveryInfo != nil {
        summaryData.deliveryInfo = menu_order.deliveryInfo!
    }
    
    for contentItem in menu_order.contentItems {
        if contentItem.orderContent.menuProductItems != nil {
            for menuProduct in contentItem.orderContent.menuProductItems! {
                let recipeString = getMenuProductItemRecipeString(item: menuProduct)
                var tmpContent: MergedContent = MergedContent()
                tmpContent.productName = menuProduct.itemName
                tmpContent.location = contentItem.orderContent.location
                tmpContent.mergedRecipe = recipeString
                tmpContent.comments = menuProduct.itemComments
                tmpContent.quantity = menuProduct.itemQuantity
                
                let index = mergedContents.firstIndex(where: {$0.productName == tmpContent.productName &&
                                                        $0.location == tmpContent.location &&
                                                        $0.mergedRecipe == tmpContent.mergedRecipe &&
                                                        $0.comments == tmpContent.comments})
                if index != nil {
                    mergedContents[index!].quantity = mergedContents[index!].quantity + tmpContent.quantity
                } else {
                    mergedContents.append(tmpContent)
                }
            }
        }
    }
    
    for content in mergedContents {
        var productInfo: ProductInfo = ProductInfo()
        productInfo.productLocation = content.location
        productInfo.productName = content.productName
        productInfo.productRecipe = content.mergedRecipe
        productInfo.productCount = content.quantity
        //productInfo.productSinglePrice = menuProduct.itemPrice
        summaryData.productList.append(productInfo)
    }
    
    return summaryData
}

func getMenuProductItemRecipeString(item: MenuProductItem) -> String {
    var recipeString: String = ""
    
    if item.menuRecipes != nil {
        for recipe in item.menuRecipes! {
            if recipe.recipeItems != nil {
                for recipeItem in recipe.recipeItems! {
                    recipeString = recipeString + recipeItem.recipeName + " "
                }
            }
        }
    }

    return recipeString
}

func getOrderStatusColor(status_code: String) -> Color {
    switch(status_code) {
    case ORDER_STATUS_NEW:
        return STATUS_COLOR_NEW
    
    case ORDER_STATUS_ACCEPT:
        return STATUS_COLOR_ACCEPT
    
    case ORDER_STATUS_REJECT:
        return STATUS_COLOR_REJECT
    
    case ORDER_STATUS_INPROCESS:
        return STATUS_COLOR_INPROCESS
    
    case ORDER_STATUS_PROCESSEND:
        return STATUS_COLOR_PROCESSEND
    
    case ORDER_STATUS_DELIVERY:
        return STATUS_COLOR_DELIVERY
    
    case ORDER_STATUS_CLOSE:
        return STATUS_COLOR_CLOSE
    
    default:
        return STATUS_COLOR_CLOSE
    }
}

func getOrderStatusString(status_code: String) -> String {
    switch(status_code) {
    case ORDER_STATUS_NEW:
        return "新進訂單"
    
    case ORDER_STATUS_ACCEPT:
        return "已接單"
    
    case ORDER_STATUS_REJECT:
        return "已拒絕"
    
    case ORDER_STATUS_INPROCESS:
        return "製作中"
    
    case ORDER_STATUS_PROCESSEND:
        return "製作完畢"
    
    case ORDER_STATUS_DELIVERY:
        return "運送中"
    
    case ORDER_STATUS_CLOSE:
        return "已結單"
    
    default:
        return "狀態錯誤"
    }
}
