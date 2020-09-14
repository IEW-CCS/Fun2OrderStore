//
//  ToDoListView.swift
//  Fun2OrderStore
//
//  Created by Lo Fang Chou on 2020/9/6.
//

import SwiftUI

struct ToDoListCellView: View {
    var toDoData: ToDoData
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(convertDateString())
                    .foregroundColor(Color.white)
                    //.font(.caption)
                    //.frame(minWidth: 0, maxWidth: .infinity, minHeight: 40)
                Text(toDoData.toDoTitle)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    //.frame(minWidth: 0, maxWidth: .infinity, minHeight: 40)
                Text(toDoData.toDoDetail)
                    .foregroundColor(Color.white)
                    //.font(.body)
                    //.frame(minWidth: 0, maxWidth: .infinity, minHeight: 40)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, alignment: .leading)
            .padding(10)
            .background(BACKGROUND_COLOR_RED)
            .cornerRadius(10)
        }
        .background(BACKGROUND_COLOR_RED)
        .cornerRadius(5)
        .overlay (
            RoundedRectangle(cornerRadius: 5)
                .stroke(BACKGROUND_COLOR_RED, lineWidth: 1.5)
        )
        .padding(10)
    }
    
    func convertDateString() -> String {
        var dateString: String = ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateString = formatter.string(from: self.toDoData.createTime)
        
        return dateString
    }
}

//struct ToDoListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ToDoListCellView(toDoData: toDoList[0])
//    }
//}
