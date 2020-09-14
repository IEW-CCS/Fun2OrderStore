//
//  MasterCell.swift
//  Fun2Order_Store
//
//  Created by Lo Fang Chou on 2020/8/27.
//  Copyright © 2020 JStudio. All rights reserved.
//

import Foundation
import SwiftUI

struct MasterCell: View {
    var data: MasterStruct
    
    var body: some View {
        HStack {
            //Spacer()
            Image(data.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            Text("\(data.functionName)")
                .font(.title)
                //.foregroundColor(.white)
            Spacer()
        }
        .offset(x: 10)
        //.background(Color(.black))
        //.listRowBackground(Color.black)
    }
}

struct MasterCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MasterCell(data: masterData[0])
            MasterCell(data: masterData[1])
            MasterCell(data: masterData[2])
            MasterCell(data: masterData[3])
        }
        .previewLayout(.fixed(width: 300, height: 100))
    }
}
