//
//  HomePage.swift
//  Fun2Order_Store
//
//  Created by Lo Fang Chou on 2020/8/30.
//  Copyright © 2020 JStudio. All rights reserved.
//

import SwiftUI
import Firebase

struct HomePage: View {
    @State private var currentDate: Date = Date()
    @State private var toDoList: [ToDoData] = [ToDoData]()
    @State private var brandMessageList: [BrandMessage] = [BrandMessage]()
    @EnvironmentObject var userAuth: UserAuth
    
    var body: some View {
        ScrollView {
            VStack {
                DatePicker("選取日期", selection: $currentDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .accentColor(BACKGROUND_COLOR_RED)
                    .padding(5)
                    .onChange(of: currentDate) { newDate in
                        self.selectedDateChange()
                    }

                Text("待辦事項")
                    .font(.largeTitle)
                    .foregroundColor(BACKGROUND_COLOR_ORANGE)
                    .padding(5)
                
                ForEach(toDoList, id:\.self)  { toDoData in
                    ToDoListCellView(toDoData: toDoData)
                        .padding()
                }
                
                Text("公司訊息")
                    .font(.largeTitle)
                    .foregroundColor(BACKGROUND_COLOR_ORANGE)
                    .padding(5)
                
                ForEach(brandMessageList, id:\.self) { brandMessage in
                    BrandInfoListView(brandMessage: brandMessage)
                        .padding()
                }
            }
        }
        .onAppear() {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            let dayString = formatter.string(from: self.currentDate)
            //self.toDoList.removeAll()
            self.toDoList = retrieveToDoList(day_string: dayString)
            print("HomePage onAppear toDoList = \(self.toDoList)")
            self.queryBrandMessages()
        }
    }

    func selectedDateChange() {
        print("new date = \(self.currentDate)")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dayString = formatter.string(from: self.currentDate)
        //self.toDoList.removeAll()
        self.toDoList = retrieveToDoList(day_string: dayString)
        print("HomePage selectedDateChange toDoList = \(self.toDoList)")
    }
    
    func queryBrandMessages() {
        downloadFBBrandMessageList(brand_name: userAuth.userControl.brandName, completion: { messageList in
            if messageList != nil {
                self.brandMessageList = messageList!
            }
        })
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
