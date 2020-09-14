//
//  EnvironmentObject.swift
//  Fun2Order_Store
//
//  Created by Lo Fang Chou on 2020/9/2.
//  Copyright © 2020 JStudio. All rights reserved.
//

import Combine

final class UserAuth: ObservableObject {
    let didChange = PassthroughSubject<UserAuth, Never>()
    let willChange = PassthroughSubject<UserAuth, Never>()
    
    @Published var userControl: StoreUserControl = StoreUserControl() {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var isLoggedIn: Bool = false {
        didSet {
            didChange.send(self)
        }
    }
    
    func login() {
        self.isLoggedIn = true
    }
    
}
