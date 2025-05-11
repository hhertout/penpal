//
//  LoginViewModel.swift
//  penpal
//

import Foundation


class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    init() {}
    
    func login() {
        
    }
}
