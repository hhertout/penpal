//
//  AppViewModel.swift
//  penpal
//

import Foundation

class AppViewModel: ObservableObject {
    @Published var isAppAlive: Bool = true
    
    @MainActor
    func checkAppHealth() async {
        var request = URLRequest(
            url: URL(
                string: "\(Constants.BACKEND_URL)/health"
            )!
        )
        request.httpMethod = "GET"

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
            isAppAlive = true
        } catch {
            print("No connection to server...")
            isAppAlive = false
        }
    }
}

