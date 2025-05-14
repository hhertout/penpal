//
//  VocubularyViewModel.swift
//  penpal
//

import Combine
import Foundation

class VocubularyViewModel: ObservableObject {
    @Published var dailyVocabulary: [VocabularyModel] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    init() {}

    @MainActor
    func getDailyVocabulary() async {
        isLoading = true
        errorMessage = nil

        var request = URLRequest(
            url: URL(
                string: "\(Constants.BACKEND_URL)/api/v1/vocabulary/daily"
            )!
        )

        let token = KeychainHelper.shared.read(
            service: "auth",
            account: "token"
        )

        if token == nil {
            errorMessage = "Il semblerait que vous ne soyez pas connecter."
            isLoading = false
            return
        }

        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        request.allHTTPHeaderFields = ["Authorization": token!]

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
                    throw ServerError(detail: "Unknown error")
                }
            }

            dailyVocabulary = try JSONDecoder().decode(
                [VocabularyModel].self,
                from: data
            )
        } catch {
            if let serverError = error as? ServerError {
                errorMessage = serverError.detail
            } else {
                errorMessage = "Une erreur serveur inattendue est survenue."
            }
        }

        if errorMessage != nil {
            print(errorMessage ?? "")
        }

        isLoading = false
    }
}
