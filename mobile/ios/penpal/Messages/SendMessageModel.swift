//
//  SendMessageModel.swift
//  penpal
//

import Foundation

struct SendMessageModel: Codable {
    public var message: String = ""
    public var conv_id: String = ""
}

struct SendMessageResponse: Decodable {
    public var response: String = ""
    public var correction: String = ""
}
