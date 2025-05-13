//
//  ConversationModel.swift
//  penpal
//

import Foundation

class ConversationModel: Decodable, Identifiable {
    var _id: String
    var name: String
    var username: String
}
