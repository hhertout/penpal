//
//  MessageModel.swift
//  penpal
//

struct MessageModel: Codable, Identifiable {
    var id: String
    var message: String
    var sender: String
    var ts: Double
    var correction: String?
    var error: Bool?

    init(id: String, message: String, sender: String, ts: Double, correction: String? = nil, error: Bool? = nil) {
        self.id = id
        self.message = message
        self.sender = sender
        self.ts = ts
        self.correction = correction
        self.error = error
    }
}
