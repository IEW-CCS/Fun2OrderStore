//
//  PostBrandEventView.swift
//  Fun2OrderStore
//
//  Created by Lo Fang Chou on 2020/9/7.
//

import SwiftUI

struct PostBrandEventView: View {
    @State private var eventData: DetailBrandEvent = DetailBrandEvent()
    @EnvironmentObject var userAuth: UserAuth
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("活動標題")
                        .frame(width: 120, alignment: .leading)
                    TextField("活動標題", text: $eventData.eventTitle)
                        .foregroundColor(.blue)
                }
                
                HStack {
                    Text("活動副標題")
                        .frame(width: 120, alignment: .leading)
                    TextField("活動副標題", text: $eventData.eventSubTitle.bound)
                        .foregroundColor(.blue)
                }

                HStack {
                    Text("活動類別")
                        .frame(width: 120, alignment: .leading)
                    TextField("活動類別", text: $eventData.eventType.bound)
                        .foregroundColor(.blue)
                }

                HStack {
                    Text("活動影像")
                        .frame(width: 120, alignment: .leading)
                    TextField("活動影像之網址", text: $eventData.eventImageURL.bound)
                        .foregroundColor(.blue)
                }
                
                HStack {
                    Text("活動內容")
                        .frame(width: 120, alignment: .leading)
                    TextField("活動內容之網址", text: $eventData.eventContentURL.bound)
                        .foregroundColor(.blue)
                }


            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .padding()
            
            Button(action: { self.updateBrandEvent() }) {
                Text("送出活動資訊")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 180, height: 40)
                    .background(BACKGROUND_COLOR_GREEN)
                    .cornerRadius(10.0)
            }
            
            Spacer()
        }
    }
    
    func updateBrandEvent() {
        print("Click to add Brand Event")
        
        updateFBBrandEvent(user_auth: userAuth, event_data: self.eventData)
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct PostBrandEventView_Previews: PreviewProvider {
    static var previews: some View {
        PostBrandEventView()
    }
}
