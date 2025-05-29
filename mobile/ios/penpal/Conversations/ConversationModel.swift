//
//  ConversationModel.swift
//  penpal
//

import Foundation

struct CharacterModel: Codable {
    var name: String = ""
    var country: String = ""
    var city: String = ""
    var gender: String = ""
}

class ConversationModel: Decodable, Identifiable {
    var _id: String
    var name: String
    var character: CharacterModel
}
