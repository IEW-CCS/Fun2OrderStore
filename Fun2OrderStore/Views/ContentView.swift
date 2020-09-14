//
//  ContentView.swift
//  Fun2Order_Store
//
//  Created by Lo Fang Chou on 2020/8/27.
//  Copyright © 2020 JStudio. All rights reserved.
//

import SwiftUI


private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()


struct ContentView: View {
    @Environment(\.managedObjectContext)
    var viewContext
    @EnvironmentObject var userAuth : UserAuth
 
    var body: some View {
        ZStack {
            if !userAuth.isLoggedIn {
                LoginView(showModal: .constant(true)).environmentObject(self.userAuth)
            } else {
                MasterView()
                    .background(Color(.black))
                    .navigationBarTitle(Text("選單"))
            }
        }
    }
}

struct MasterView: View {
    @Environment(\.managedObjectContext)
    var viewContext
    @State private var selectedView: Int? = 0

    var body: some View {
        NavigationView {
            List(masterData) { functionData in
                if functionData.id == 0 {
                    NavigationLink(destination: HomePage().navigationBarTitle("首頁", displayMode: .inline), tag: functionData.id, selection: self.$selectedView) {
                        MasterCell(data: functionData)
                    }
                }
                
                if functionData.id == 1 {
                    NavigationLink(destination: OrderListView().navigationBarTitle("訂單列表", displayMode: .inline), tag: functionData.id, selection: self.$selectedView) {
                        MasterCell(data: functionData)
                    }
                }
                
                if functionData.id == 2 {
                    NavigationLink(destination: DataMaintainView().navigationBarTitle("資料維護", displayMode: .inline), tag: functionData.id, selection: self.$selectedView) {
                        MasterCell(data: functionData)
                    }
                }
                
                if functionData.id == 3 {
                    NavigationLink(destination: ReportView().navigationBarTitle("報表系統", displayMode: .inline), tag: functionData.id, selection: self.$selectedView) {
                        MasterCell(data: functionData)
                    }
                }
                
                if functionData.id == 4 {
                    NavigationLink(destination: SettingView().navigationBarTitle("設定", displayMode: .inline), tag: functionData.id, selection: self.$selectedView) {
                        MasterCell(data: functionData)
                    }
                }
            }
            .navigationBarTitle("功能列表")
        }
        .onAppear {
            print("NavigationView onAppear")
            self.selectedView = 0
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
