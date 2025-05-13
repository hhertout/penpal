//
//  ConversationViewModel.swift
//  penpal
//

import Combine
import Foundation

class ConversationViewModel: ObservableObject {
    @Published var conversations: [ConversationModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init() {}

    func getConversations() async {
        isLoading = true
        errorMessage = nil

        var request = URLRequest(
            url: URL(string: "\(Constants.BACKEND_URL)/api/v1/conv")!
        )
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]

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
            
            conversations = try JSONDecoder().decode([ConversationModel].self, from: data)
        } catch {
            if let serverError = error as? ServerError {
                errorMessage = serverError.detail
            } else {
                errorMessage = error.localizedDescription
            }
        }
        
        isLoading = false
    }
}
