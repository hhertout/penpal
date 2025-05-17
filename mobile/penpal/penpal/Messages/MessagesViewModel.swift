//
//  MessagesViewModel.swift
//  penpal
//

import Foundation

class MessagesViewModel: ObservableObject {
    @Published var messages: [MessageModel] = []
    @Published var sendMessageModel = SendMessageModel()
    @Published var isLoading: Bool = false

    init(convId: String) {
        self.sendMessageModel.conv_id = convId
    }

    @MainActor
    func getMessages(convId: String) async {

        let token = AuthHelper.getAuthToken()
        if token == nil {
            print("Unauthorized")
        }

        var request = URLRequest(
            url: URL(
                string: "\(Constants.BACKEND_URL)/api/v1/messages/\(convId)"
            )!
        )

        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        request.allHTTPHeaderFields = ["Authorization": token ?? ""]

        do {
            let (data, response) = try await URLSession.shared.data(
                for: request
            )

            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
            else {
                if let serverError = try? JSONDecoder().decode(
                    ServerError.self,
                    from: data
                ) {
                    throw serverError
                } else {
                    throw ServerError(detail: "Erreur inconnue")
                }
            }

            messages = try JSONDecoder().decode([MessageModel].self, from: data)
        } catch {
            print("Error: \(error)")
        }
    }

    @MainActor
    func sendMessage() async {
        isLoading = true
        let token = AuthHelper.getAuthToken()
        if token == nil {
            print("Unauthorized")
        }

        var request = URLRequest(
            url: URL(string: "\(Constants.BACKEND_URL)/api/v1/message")!
        )
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        request.allHTTPHeaderFields = ["Authorization": token ?? ""]
        
        #if DEBUG
        print("convid=\(sendMessageModel.conv_id)")
        print("message=\(sendMessageModel.message)")
        #endif

        request.httpBody = try? JSONSerialization.data(
            withJSONObject: [
                "message": sendMessageModel.message,
                "conv_id": sendMessageModel.conv_id,
            ]
        )

        do {
            addMessagePredicate()
            let (data, response) = try await URLSession.shared.data(
                for: request
            )

            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
            else {
                if let serverError = try? JSONDecoder().decode(
                    ServerError.self,
                    from: data
                ) {
                    throw serverError
                } else {
                    throw ServerError(detail: "Erreur inconnue")
                }
            }

            let res = try JSONDecoder().decode(
                SendMessageResponse.self,
                from: data
            )
            
            print("Response: \(res)")

            insertResponseInMessages(res)
        } catch {
            #if DEBUG
            print(error)
            #endif
        }
        
        isLoading = false
    }

    func insertResponseInMessages(_ response: SendMessageResponse) {
        let el = removeMessagePredicate()
        
        let ai_msg = MessageModel(
            id: "\(Int.random(in: 0..<100))",
            message: response.response,
            sender: "ai",
            ts: Date().timeIntervalSince1970,
        )
        
        let user_msg = MessageModel(
            id: el.id,
            message: el.message,
            sender: el.sender,
            ts: el.ts,
            correction: response.correction,
        )
        
        messages.append(user_msg)
        messages.append(ai_msg)
    }

    func addMessagePredicate() {
        let msg = MessageModel(
            id: "\(Int.random(in: 0..<100))",
            message: sendMessageModel.message,
            sender: "user",
            ts: Date().timeIntervalSince1970,
        )
        messages.append(msg)
        sendMessageModel.message = ""
    }

    func removeMessagePredicate() -> MessageModel {
        return messages.removeLast()
    }
}
