//
//  GlobalConstants.swift
//  Fun2Order_Store
//
//  Created by Lo Fang Chou on 2020/8/29.
//  Copyright © 2020 JStudio. All rights reserved.
//

import Foundation
import SwiftUI

let masterData: [MasterStruct] = load("MasterList.json")
//var testOrderList: [OrderSummaryData] = load("TestOrderData.json")
//var toDoList: [ToDoData] = load("ToDoList.json")
//var brandInfoList: [BrandInformation] = load("BrandInfoList.json")
var salesList: [SalesReport] = load("SalesReport.json")

let BACKGROUND_COLOR_RED = Color(red: 239.0/255.0, green: 83.0/255.0, blue: 80.0/255.0, opacity: 1.0)
let BACKGROUND_COLOR_GREEN = Color(red: 67.0/255.0, green: 149.0/255.0, blue: 114.0/255.0, opacity: 1.0)
let BACKGROUND_COLOR_ORANGE = Color(red: 226.0/255.0, green: 105.0/255.0, blue: 43.0/255.0, opacity: 1.0)
let BACKGROUND_COLOR_LIGHTORANGE = Color(red: 255.0/255.0, green: 167.0/255.0, blue: 38.0/255.0, opacity: 1.0)
let BACKGROUND_COLOR_DEEPBLUE = Color(red: 7.0/255.0, green: 28.0/255.0, blue: 43.0/255.0, opacity: 1.0)
let BACKGROUND_COLOR_LIGHTGRAY = Color(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, opacity: 1.0)
let BACKGROUND_COLOR_LIGHTBLUE = Color(red: 3.0/255.0, green: 155.0/255.0, blue: 229.0/255.0, opacity: 1.0)

let TODO_STATUS_OPEN: String = "OPEN"
let TODO_STATUS_CLOSE: String = "CLOSE"

let DELIVERY_TYPE_TAKEOUT: String = "TAKEOUT"
let DELIVERY_TYPE_DELIVERY: String = "DELIVERY"

let BRAND_INFORMATION_MAX_COUNT: Int = 2

let ORDER_STATUS_INIT: String = "INIT"          // Initial and editing state of the order
let ORDER_STATUS_NEW: String = "NEW"            // User create the real order and send to store
let ORDER_STATUS_ACCEPT: String = "ACCEPT"      // Store manager confirms to receive the real order
let ORDER_STATUS_REJECT: String = "REJECT"      // Store manager rejects the real order
let ORDER_STATUS_INPROCESS: String = "INPR"     // Store starts making the content of the order
let ORDER_STATUS_PROCESSEND: String = "PREN"        // Store gets the order ready to take out or deliver
let ORDER_STATUS_DELIVERY: String = "DELIVERY"  // Products in delivery
let ORDER_STATUS_CLOSE: String = "CLOSE"        // Customer receives products and finishes this order

let STATUS_COLOR_NEW = Color(red: 216.0/255.0, green: 27.0/255.0, blue: 96.0/255.0, opacity: 1.0)
let STATUS_COLOR_ACCEPT = Color(red: 3.0/255.0, green: 155.0/255.0, blue: 229.0/255.0, opacity: 1.0)
let STATUS_COLOR_REJECT = Color(red: 109.0/255.0, green: 76.0/255.0, blue: 65.0/255.0, opacity: 1.0)
let STATUS_COLOR_INPROCESS = Color(red: 142.0/255.0, green: 36.0/255.0, blue: 170.0/255.0, opacity: 1.0)
let STATUS_COLOR_PROCESSEND = Color(red: 57.0/255.0, green: 73.0/255.0, blue: 171.0/255.0, opacity: 1.0)
let STATUS_COLOR_DELIVERY = Color(red: 0.0/255.0, green: 137.0/255.0, blue: 123.0/255.0, opacity: 1.0)
let STATUS_COLOR_CLOSE = Color(red: 84.0/255.0, green: 110.0/255.0, blue: 122.0/255.0, opacity: 1.0)

let STORE_NOTIFICATION_TYPE_NEW_ORDER = "NEW_ORDER"
let STORE_NOTIFICATION_TYPE_BRAND_MESSAGE = "BRAND_MESSAGE"

let OS_TYPE_IOS = "iOS"
let OS_TYPE_ANDROID = "Android"

let DATETIME_FORMATTER_DATE: String = "yyyyMMdd"
let DATETIME_FORMATTER: String = "yyyyMMddHHmmssSSS"
let DATETIME_FORMATTER2: String = "yyyyMMddHHmmss"
let TAIWAN_DATETIME_FORMATTER: String = "yyyy年MM月dd日 HH:mm:ss"
let TAIWAN_DATETIME_FORMATTER2: String = "yyyy年MM月dd日 HH:mm"
let DATE_FORMATTER: String = "yyyy年MM月dd日"
