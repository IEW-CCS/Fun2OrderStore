//
//  BrandStruct.swift
//  Fun2Order
//
//  Created by Lo Fang Chou on 2020/6/11.
//  Copyright © 2020 JStudio. All rights reserved.
//

import Foundation
import UIKit
import MapKit

struct DetailBrandCategory: Codable {
    var brandName: String = ""
    var brandIconImage: String?
    var brandCategory: String?
    var brandSubCategory: String?
    var updateDateTime: String = ""
    var imageDownloadUrl: String?
    var coworkBrandFlag: Bool?
    
    func toAnyObject() -> Any {
        return [
            "brandName": brandName,
            "brandIconImage": brandIconImage as Any,
            "brandCategory": brandCategory as Any,
            "brandSubCategory": brandSubCategory as Any,
            "updateDateTime": updateDateTime,
            "imageDownloadUrl": imageDownloadUrl as Any,
            "coworkBrandFlag": coworkBrandFlag as Any
        ]
    }
}

struct DetailBrandListStruct{
    var index: Int = 0
    var brandData: DetailBrandCategory = DetailBrandCategory()
    var brandImage: UIImage?
}

struct DetailBrandProfile: Codable {
    var brandName: String = ""
    var menuNumber: String = ""
    var brandIconImage: String?
    var brandCategory: String?
    var brandSubCategory: String?
    var brandDescription: String?
    var storeCategory: [String]?
    var storeSubCategory: [String]?
    //var storeInfo: [DetailStoreInformation]?
    var officialWebURL: String?
    var facebookURL: String?
    var instagramURL: String?
    var updateDateTime: String = ""
    var imageDownloadUrl: String?
    var brandStoryURL: String?
    var brandEventBannerURL: String?
    var brandMenuBannerURL: String?
    //var brandEvents: [DetailBrandEvent]?
    var brandStyle: DetailStyle?
    var coworkBrandFlag: Bool?

    func toAnyObject() -> Any {
        //var storeArray: [Any] = [Any]()
        //var eventArray: [Any] = [Any]()
        
        /*
        if storeInfo != nil {
            for itemData in (storeInfo as [DetailStoreInformation]?)! {
                storeArray.append(itemData.toAnyObject())
            }
        }

        if brandEvents != nil {
            for itemData in (brandEvents as [DetailBrandEvent]?)! {
                eventArray.append(itemData.toAnyObject())
            }
        }
        */

        return [
            "brandName": brandName,
            "menuNumber": menuNumber,
            "brandIconImage": brandIconImage as Any,
            "brandCategory": brandCategory as Any,
            "brandSubCategory": brandSubCategory as Any,
            "brandDescription": brandDescription as Any,
            "storeCategory": storeCategory as Any,
            "storeSubCategory": storeSubCategory as Any,
            //"storeInfo": storeArray,
            "officialWebURL": officialWebURL as Any,
            "facebookURL": facebookURL as Any,
            "instagramURL": instagramURL as Any,
            "updateDateTime": updateDateTime,
            "imageDownloadUrl": imageDownloadUrl as Any,
            "brandStoryURL": brandStoryURL as Any,
            "brandEventBannerURL": brandEventBannerURL as Any,
            "brandMenuBannerURL": brandMenuBannerURL as Any,
            //"brandEvents": eventArray,
            "brandStyle": brandStyle?.toAnyObject() as Any,
            "coworkBrandFlag": coworkBrandFlag as Any
        ]
    }
}

struct DetailStyle: Codable {
    var backgroundColor: [Float]?
    var tabBarColor: [Float]?
    var textTintColor: [Float]?
    
    func toAnyObject() -> Any {
        return [
            "backgroundColor": backgroundColor as Any,
            "tabBarColor": tabBarColor as Any,
            "textTintColor": textTintColor as Any
        ]
    }
}

struct DetailBrandEvent: Codable {
    var eventTitle: String = ""
    var eventSubTitle: String?
    var eventType: String?
    var eventImageURL: String?
    var eventContentURL: String?
    var eventContent: String?
    var publishDate: String = ""

    func toAnyObject() -> Any {
        return [
            "eventTitle": eventTitle,
            "eventSubTitle": eventSubTitle as Any,
            "eventType": eventType as Any,
            "eventImageURL": eventImageURL as Any,
            "eventContentURL": eventContentURL as Any,
            "eventContent": eventContent as Any,
            "publishDate": publishDate
        ]
    }
}

struct DetailMenuInformation: Codable {
    var brandName: String = ""
    var menuNumber: String = ""
    var menuDescription: String?
    var multiMenuImageURL: [String]?
    //var locations: [String]?
    var productCategory: [DetailProductCategory]?
    var recipeTemplates: [DetailRecipeTemplate]?
    var createTime: String = ""

    func toAnyObject() -> Any {
        var categoryArray: [Any] = [Any]()
        var templateArray: [Any] = [Any]()
        
        if productCategory != nil {
            for itemData in (productCategory as [DetailProductCategory]?)! {
                categoryArray.append(itemData.toAnyObject())
            }
        }

        if recipeTemplates != nil {
            for itemData in (recipeTemplates as [DetailRecipeTemplate]?)! {
                 templateArray.append(itemData.toAnyObject())
             }
        }
        
        return [
            "brandName": brandName,
            "menuNumber": menuNumber,
            "menuDescription": menuDescription as Any,
            "multiMenuImageURL": multiMenuImageURL as Any,
            "productCategory": categoryArray,
            "recipeTemplates": templateArray,
            "createTime": createTime
        ]
    }
}

struct DetailProductCategory: Codable {
    var categoryName: String = ""
    var priceTemplate: DetailRecipeTemplate = DetailRecipeTemplate()
    var productItems: [DetailProductItem]?
    
    func toAnyObject() -> Any {
        var productArray: [Any] = [Any]()
        if productItems != nil {
             for itemData in (productItems as [DetailProductItem]?)! {
                 productArray.append(itemData.toAnyObject())
             }
         }
        
        return [
            "categoryName": categoryName,
            "priceTemplate": priceTemplate.toAnyObject(),
            "productItems": productArray
        ]
    }
}

struct DetailProductItem: Codable {
    var productName: String = ""
    var productCategory: String?
    var productSubCategory: String?
    var productDescription: String?
    var productImageURL: [String]?
    var productWebURL: String?
    var productBasicPrice: Int = 0
    var recipeRelation: [DetailRecipeRelation]?
    var priceList: [DetailRecipeItemPrice]?

    func toAnyObject() -> Any {
        var priceArray: [Any] = [Any]()
        var relationArray: [Any] = [Any]()
        
        if priceList != nil {
            for itemData in (priceList as [DetailRecipeItemPrice]?)! {
                priceArray.append(itemData.toAnyObject())
            }
        }

        if recipeRelation != nil {
            for itemData in (recipeRelation as [DetailRecipeRelation]?)! {
                relationArray.append(itemData.toAnyObject())
            }
        }

        return [
            "productName": productName,
            "productCategory": productCategory as Any,
            "productSubCategory": productSubCategory as Any,
            "productDescription": productDescription as Any,
            "productImageURL": productImageURL as Any,
            "productWebURL": productWebURL as Any,
            "productBasicPrice": productBasicPrice,
            "recipeRelation": relationArray,
            "priceList": priceArray
        ]
    }
}

struct DetailRecipeRelation: Codable {
    var templateSequence: Int = 0
    var itemRelation: [Bool] = [Bool]()
    
    func toAnyObject() -> Any {
        return [
            "templateSequence": templateSequence,
            "itemRelation": itemRelation
        ]
    }
}

struct DetailRecipeItemPrice: Codable {
    var recipeItemName: String = ""
    var price: Int = 0
    var availableFlag: Bool = false

    func toAnyObject() -> Any {
        return [
            "recipeItemName": recipeItemName,
            "price": price,
            "availableFlag": availableFlag
        ]
    }
}

struct DetailRecipeTemplate: Codable {
    var templateSequence: Int = 0
    var templateName: String = ""
    var templateCategory: String?
    var mandatoryFlag: Bool = false
    var allowMultiSelectionFlag: Bool = false
    var standAloneProduct: Bool = false
    var recipeList: [DetailRecipeItem] = [DetailRecipeItem]()

    func toAnyObject() -> Any {
        var recipeArray: [Any] = [Any]()

        for itemData in (recipeList as [DetailRecipeItem]) {
            recipeArray.append(itemData.toAnyObject())
        }
        
        return [
            "templateSequence": templateSequence,
            "templateName": templateName,
            "templateCategory": templateCategory as Any,
            "mandatoryFlag": mandatoryFlag,
            "allowMultiSelectionFlag": allowMultiSelectionFlag,
            "standAloneProduct": standAloneProduct,
            "recipeList": recipeArray
        ]
    }
}

struct DetailRecipeItem: Codable {
    var itemSequence: Int = 0
    var itemName: String = ""
    var itemCheckedFlag: Bool = false
    var optionalPrice: Int = 0
    var itemDisplayFlag: Bool?

    func toAnyObject() -> Any {
        return [
            "itemSequence": itemSequence,
            "itemName": itemName,
            "itemCheckedFlag": itemCheckedFlag,
            "optionalPrice": optionalPrice,
            "itemDisplayFlag": itemDisplayFlag as Any
        ]
    }
}

struct BrandSuggestionData: Codable {
    var brandName: String = ""
    var brandImageURL: String = ""
    var suggestedUserID: String = ""
    var suggestedDateTime: String = ""
    
    func toAnyObject() -> Any {
        return [
            "brandName": brandName,
            "brandImageURL": brandImageURL,
            "suggestedUserID": suggestedUserID,
            "suggestedDateTime": suggestedDateTime
        ]
    }
}

struct DetailStoreInformation: Codable {
    var storeID: Int = 0
    var storeName: String = ""
    var storeMenuNumber: String = ""
    var storeCategory: String?
    var storeSubCategory: String?
    var storeDescription: String?
    var storeLatitude: String?
    var storeLongitude: String?
    var storeWebURL: String?
    var storeFacebookURL: String?
    var storeInstagramURL: String?
    var storeImageURL: String?
    var storeAddress: String?
    var storePhoneNumber: String?
    var deliveryServiceFlag: Bool = false
    var deliveryService: [DeliveryServiceDefinition]?
    var businessTime: BusinessTime?
    var storeState: String?
    var normalProcessTime: Int?
    var busyProcessTime: Int?

    func toAnyObject() -> Any {
        var deliveryArray: [Any] = [Any]()

        if deliveryService != nil {
            for itemData in (deliveryService as [DeliveryServiceDefinition]?)! {
                deliveryArray.append(itemData.toAnyObject())
            }
        }

        return [
            "storeID": storeID,
            "storeName": storeName,
            "storeMenuNumber": storeMenuNumber,
            "storeCategory": storeCategory as Any,
            "storeSubCategory": storeSubCategory as Any,
            "storeDescription": storeDescription as Any,
            "storeLatitude": storeLatitude as Any,
            "storeLongitude": storeLongitude as Any,
            "storeWebURL": storeWebURL as Any,
            "storeFacebookURL": storeFacebookURL as Any,
            "storeInstagramURL": storeInstagramURL as Any,
            "storeImageURL": storeImageURL as Any,
            "storeAddress": storeAddress as Any,
            "storePhoneNumber": storePhoneNumber as Any,
            "deliveryServiceFlag": deliveryServiceFlag,
            "deliveryService": deliveryArray,
            "businessTime": businessTime?.toAnyObject() as Any,
            "storeState": storeState as Any,
            "normalProcessTime": normalProcessTime as Any,
            "busyProcessTime": busyProcessTime as Any
        ]
    }
}

struct DeliveryServiceDefinition: Codable {
    var itemName: String = ""
    var itemDescription: String = ""
    
    func toAnyObject() -> Any {
        return [
            "itemName": itemName,
            "itemDescription": itemDescription
        ]
    }
}

struct BusinessTime: Codable {
    var dayOffFlag: Bool = false
    var openTime: String = "08:00:00"
    var closeTime: String = "22:00:00"
    
    func toAnyObject() -> Any {
        return [
            "dayOffFlag": dayOffFlag,
            "openTime": openTime,
            "closeTime": closeTime
        ]
    }
}

struct ProductInfo: Codable, Hashable {
    var productLocation: String = "''"
    var productName: String = ""
    var productRecipe: String = ""
    var productCount: Int = 0
    var productSinglePrice: Int = 0
}

struct OrderSummaryData: Codable, Hashable {
    var orderStatus: String = ""
    var ownerUID: String = ""
    var orderNumber: String = ""
    var totalCount: Int = 0
    var totalPrice: Int = 0
    var updateTime: String = ""
    var deliveryInfo: MenuOrderDeliveryInformation = MenuOrderDeliveryInformation()
    var productList: [ProductInfo] = [ProductInfo]()
}

struct ToDoData: Codable, Hashable {
    var createTime: Date = Date()
    var targetTime: Date = Date()
    var dayString: String = ""
    var owner: String = ""
    var status: String = ""
    var toDoTitle: String = ""
    var toDoDetail: String = ""
}

struct OrderHistoryRecord: Codable, Hashable {
    var claimTimeStamp: String = ""
    var claimUser: String = ""
    var claimStatus: String = ""
    
    func toAnyObject() -> Any {
        return [
            "claimTimeStamp": claimTimeStamp,
            "claimUser": claimUser,
            "claimStatus": claimStatus
        ]
    }
}

struct activityShortageItem: Codable, Identifiable {
    var id : UUID = UUID()
    var category : String
    var product : String
    var isShortage : Bool
    
    init(category: String, product: String, isShortage: Bool) {
        self.category = category
        self.product = product
        self.isShortage = isShortage
    }
}

struct ActivityAttendMember: Codable {
    var memberID: String = ""
    var memberToken: String = ""
    var memberName: String = ""
    var replyStatus: String = ""
    var replyDateTime: String = ""
    var estimateCost: Int = 0
    var activityTimeSlot: ActivityTimeSlot?
    var activityAttendTypes: [ActivityAttendType]?
}

struct ActivityAttendType: Codable {
    var typeName: String = ""
    var typeCount: Int = 0
    var typeDescription: String?
    var typeCost: Int = 0
}

struct ActivityTimeSlot: Codable {
    var fromTime: String = ""
    var toTime: String = ""
    var countLimit: Int = 0
    //var attendMembers: [ActivityAttendMember]?
}

struct ActivityInformation: Codable {
    var avtivityID: String = ""
    var activityDescription: String?
    var avtivityImages: [String]?
    var avtivityLocation: String = ""
    var activityMapAddress: String?
    var avtivityDateTime: String = ""
    var activityTrafficType: String?
    var attendCountLimit: Int = 0
    var activityTimeSlot: [ActivityTimeSlot]?
    var activityAttendTypes: [ActivityAttendType]?
}

struct ActivityEvent: Codable {
    var eventID: String = ""
    var activityInfoID: String = ""
    var attendMembers: [ActivityAttendMember]?
}
