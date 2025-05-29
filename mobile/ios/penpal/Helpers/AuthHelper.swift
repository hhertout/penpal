//
//  AuthHelper.swift
//  penpal
//

import Foundation

class AuthHelper {
    static func getAuthToken() -> String? {
        return KeychainHelper.shared.read(
            service: "auth",
            account: "token"
        )
    }
}
