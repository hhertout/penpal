//
//  AddConversationViewModel.swift
//  penpal
//

import Foundation

class AddConversationViewModel: ObservableObject {
    @Published var model: AddConversationModel = .init()
    
    @Published var isLoading: Bool = false
    
    init() {
        
    }
    
    @MainActor
    func addConversation() async {
        isLoading = true
        
        let token = AuthHelper.getAuthToken()
        
        if token == nil {
            // todo
        }
        
        var request = URLRequest(
            url: URL(string: "\(Constants.BACKEND_URL)/api/v1/conv/new")!
        )
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        request.allHTTPHeaderFields = ["Authorization": token ?? ""]
        
        model.name = model.character.name
        let encoder = JSONEncoder()
        request.httpBody = try? encoder.encode(model)
        
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
        } catch {
            print(error)
        }
        
        isLoading = false
    }
}
