//
//  BindindDataStruct.swift
//  Fun2Order_Store
//
//  Created by Lo Fang Chou on 2020/9/3.
//  Copyright © 2020 JStudio. All rights reserved.
//

import Foundation

struct SelectedBrandStoreData {
    var brandName: String = ""
    var storeName: String = ""
}

struct SalesReport: Codable, Hashable {
    var rank: Int = 0
    var previous_rank: Int = 0
    var storeName: String = ""
    var salesMoney: Int = 0
    var bestSaleProduct: String = ""
}
