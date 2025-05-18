//
//  AddConversationModel.swift
//  penpal
//

import Foundation

struct AddCharacterModel: Codable {
    var name: String = ""
    var country: String = ""
    var city: String = ""
    var gender: String = ""
}

struct AddConversationModel: Codable {
    var name: String = ""
    var character = AddCharacterModel()
}
