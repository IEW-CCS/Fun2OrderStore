//
//  AssignShortageView.swift
//  Fun2OrderStore
//
//  Created by Lo Fang Chou on 2020/9/7.
//

import SwiftUI

struct AssignShortageView: View {
    @State private var selectedIndex: Int = 0
    private let categories: [String] = ["頂級茶道", "濃郁雪浮", "純天然鮮奶", "口感鮮茶"]
    private let items: [[String]] = [["上宇林青茶", "上宇林紅茶", "三窨花綠茶", "蟲蝕烏龍茶"],
                                     ["雪浮奶紅茶", "雪浮奶綠茶", "雪浮奶青茶", "雪浮奶烏龍茶", "雪浮奶美人"],
                                     ["鼎級鮮奶茶", "太極鮮奶茶", "紅龍鮮奶茶", "鐵觀音鮮奶茶", "鮮奶綠茶", "鮮奶青茶"],
                                     ["黃金多多綠", "梅香綠茶", "脆梅綠茶", "冬瓜茶", "冬瓜青茶"]]
    var body: some View {
        //ScrollView {
            VStack {
                Text("請勾選目前缺貨之產品")
                    .font(.title)
                
                Text("目前選取之類別項數: \(items[selectedIndex].count)")
                Picker(selection: $selectedIndex, label: Text("")) {
                    ForEach(0 ..< categories.count) {
                        Text(self.categories[$0])
                    }
                }
                .labelsHidden()
                .pickerStyle(SegmentedPickerStyle())
                
                Form {
                    ForEach(0 ..< items[self.selectedIndex].count) { index in
                        Text(self.items[self.selectedIndex][index])
                            .padding()
                    }
                }

                Button(action: {print("Click to assign product shortage")}) {
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
        //}
    }
}

struct AssignShortageView_Previews: PreviewProvider {
    static var previews: some View {
        AssignShortageView()
    }
}
