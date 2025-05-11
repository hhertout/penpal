//
//  KeyChainHelper.swift
//  penpal
//

import Foundation
import Security

class KeychainHelper {
    static let shared = KeychainHelper()

    func save(_ data: String, service: String, account: String) {
        let data = Data(data.utf8)

        let query =
            [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account,
            ] as CFDictionary
        SecItemDelete(query)

        let attributes =
            [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecValueData: data,
            ] as CFDictionary

        let status = SecItemAdd(attributes, nil)
        assert(status == errSecSuccess, "Failed to save to keychain")
    }

    func read(service: String, account: String) -> String? {
        let query =
            [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecReturnData: true,
                kSecMatchLimit: kSecMatchLimitOne,
            ] as CFDictionary

        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        guard let data = result as? Data else { return nil }
        return String(decoding: data, as: UTF8.self)
    }
    
    func remove(service: String, account: String) {
        let query =
            [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account,
            ] as CFDictionary
        SecItemDelete(query)
    }
}
