//
//  ChangeBusinessHourView.swift
//  Fun2OrderStore
//
//  Created by Lo Fang Chou on 2020/9/7.
//

import SwiftUI

struct ChangeBusinessHourView: View {
    @State private var dayOff: Bool = false
    @State private var currentDate: Date = Date()
    @State private var openDate: Date = Date()
    @State private var closeDate: Date = Date()
    @EnvironmentObject var userAuth: UserAuth
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ScrollView {
            VStack {
                DatePicker("選取營業日期", selection: $currentDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .accentColor(BACKGROUND_COLOR_RED)
                    .padding()
                
                Text(convertSelectedDate())
                    .font(.largeTitle)
                    .foregroundColor(BACKGROUND_COLOR_ORANGE)
                    .padding()
                
                Toggle(isOn: $dayOff) {
                    Text("休假日？")
                        .padding()
                }
                .padding()

                Text("更改營業時間")
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding()

                if UIDevice.current.userInterfaceIdiom == .pad {
                    ScrollView(.horizontal) {
                        HStack {
                            VStack {
                                Text("開始時間")
                                DatePicker("", selection: $openDate, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(WheelDatePickerStyle())
                                    .labelsHidden()
                                    .accentColor(.blue)
                                    .padding()
                                    .clipped()
                            }

                            VStack {
                                Text("結束時間")
                                DatePicker("", selection: $closeDate, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(WheelDatePickerStyle())
                                    .labelsHidden()
                                    .accentColor(.blue)
                                    .padding()
                                    .clipped()
                            }
                        }
                        .clipped()
                        .padding()
                    }
                } else {
                    VStack {
                        Text("開始時間")
                        DatePicker("", selection: $openDate, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            .accentColor(.blue)
                            .padding()
                            .clipped()
                    }

                    VStack {
                        Text("結束時間")
                        DatePicker("", selection: $closeDate, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            .accentColor(.blue)
                            .padding()
                            .clipped()
                    }
                }
                
                
                Button(action: { self.updateBusinessTime() }) {
                    Text("更改時間")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 120, height: 40)
                        .background(BACKGROUND_COLOR_GREEN)
                        .cornerRadius(10.0)
                }
                
                Spacer()
            }
        }
    }
    
    func convertSelectedDate() -> String {
        var dateString: String = ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        
        dateString = formatter.string(from: self.currentDate)
        
        return dateString
    }
    
    func updateBusinessTime() {
        var businessTime: BusinessTime = BusinessTime()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        businessTime.dayOffFlag = self.dayOff
        businessTime.openTime = formatter.string(from: self.openDate) + ":00"
        businessTime.closeTime = formatter.string(from: self.closeDate) + ":00"
        
        updateFBStoreBusinessTime(user_auth: userAuth, change_date: currentDate, business_time: businessTime)
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct ChangeBusinessHourView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeBusinessHourView()
    }
}
