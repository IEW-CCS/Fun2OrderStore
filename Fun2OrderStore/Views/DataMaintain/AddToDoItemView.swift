//
//  AddToDoItemView.swift
//  Fun2OrderStore
//
//  Created by Lo Fang Chou on 2020/9/7.
//

import SwiftUI

struct AddToDoItemView: View {
    @State private var currentDate: Date = Date()
    @State private var targetTime: Date = Date()
    @State private var toDoItem: String = ""
    @State private var toDoTitle: String = ""
    @State private var targetTimeFlag: Bool = false
    @State var toDoData: ToDoData = ToDoData()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ScrollView {
            VStack {
                DatePicker("選取日期", selection: $currentDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .accentColor(BACKGROUND_COLOR_RED)
                    .padding()
                
                Toggle(isOn: $targetTimeFlag) {
                    Text("指定時間")
                }
                
                if self.targetTimeFlag {
                    DatePicker("", selection: $targetTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .accentColor(.blue)
                        .padding()
                        .frame(height: 150)
                }
                
                Text("待辦事項")
                    .font(.title)
                    .padding()
                
                HStack {
                    Text("負責人")
                        .frame(width: 100)
                        .font(.title)
                    TextField("請輸入負責人", text: $toDoData.owner)
                        .frame(width: 200)
                        .foregroundColor(.blue)
                        .padding()
                        .overlay (
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1.5)
                        )
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding()

                HStack {
                    Text("標題")
                        .frame(width: 100)
                        .font(.title)
                    TextField("請輸入待辦事項之標題", text: $toDoData.toDoTitle)
                        .lineLimit(0)
                        .frame(width: 200)
                        .foregroundColor(.blue)
                        .padding()
                        .overlay (
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1.5)
                        )
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding()
                
                //TextField("請輸入待辦事項之描述", text: $toDoData.toDoDetail)
                TextEditor(text: $toDoData.toDoDetail)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 200)
                    .foregroundColor(.blue)
                    .padding()
                    .overlay (
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1.5)
                    )
                
                Button(action: {self.addToDoItem()}) {
                    Text("新增待辦事項")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 180, height: 40)
                        .background(BACKGROUND_COLOR_GREEN)
                        .cornerRadius(10.0)
                }
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 200)
            .padding()
        }
    }
    
    func addToDoItem() {
        print("Click to add ToDo item")
        
        if self.toDoData.toDoTitle == "" {
            presentSimpleAlertMessage(title: "錯誤訊息", message: "請輸入待辦事項的標題")
            return
        }

        if self.toDoData.toDoDetail == "" {
            presentSimpleAlertMessage(title: "錯誤訊息", message: "請輸入待辦事項的詳細描述")
            return
        }

        self.toDoData.createTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dayString = formatter.string(from: self.currentDate)
        self.toDoData.dayString = dayString
        self.toDoData.status = TODO_STATUS_OPEN
        
        var timeString: String = ""
        if self.targetTimeFlag {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HHmmss"
            timeString = timeFormatter.string(from: targetTime)
        } else {
            timeString = "000000"
        }
        
        let dateTimeString = dayString + timeString
        let dayTimeFormatter = DateFormatter()
        dayTimeFormatter.dateFormat = "yyyyMMddHHmmss"
        let date = dayTimeFormatter.date(from: dateTimeString)
        self.toDoData.targetTime = date!
        
        insertToDoItem(item: self.toDoData)
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AddToDoItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddToDoItemView()
    }
}
