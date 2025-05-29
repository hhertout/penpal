//
//  Session.swift
//  penpal
//

import Foundation

class Session: ObservableObject {
    @Published var user: String? = nil
    @Published var isLoggedIn = false
}
