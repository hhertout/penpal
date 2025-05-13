//
//  LoginViewModel.swift
//  penpal
//

import Combine
import Foundation

struct AuthResponse: Codable {
    let token: String
    let username: String
}

struct ServerError: Error, Codable {
    let detail: String
}

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""

    @Published var isLoading: Bool = false
    @Published var isLogginLoading: Bool = false
    
    @Published var errorMessage: String? = nil

    private var session: Session

    private var cancellables: Set<AnyCancellable> = []

    init(session: Session) {
        self.session = session
    }

    @MainActor
    func checkAuthentication() async {
        self.isLoading = true

        if let token = KeychainHelper.shared.read(
            service: "app",
            account: "token"
        ),
            !token.isEmpty
        {
            // TODO: call API to validate token
            self.session.isLoggedIn = true
        } else {
            self.session.isLoggedIn = false
        }

        self.isLoading = false
    }

    @MainActor
    func login() async {
        errorMessage = nil
        isLogginLoading = true

        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Veuillez remplir tous les champs"
            isLogginLoading = false
            return
        }

        var request = URLRequest(
            url: URL(string: "\(Constants.BACKEND_URL)/api/v1/login")!
        )
        request.httpMethod = "POST"
        let body = ["username": username, "password": password]
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                if let serverError = try? JSONDecoder().decode(ServerError.self, from: data) {
                    throw serverError
                } else {
                    throw ServerError(detail: "Erreur inconnue")
                }
            }

            let auth = try JSONDecoder().decode(AuthResponse.self, from: data)
            
            print("User \(auth.username) logged in")

            KeychainHelper.shared.save(
                auth.token,
                service: "auth",
                account: "token"
            )

            session.user = auth.username
            session.isLoggedIn = true
            username = ""
            password = ""
        } catch let error as ServerError {
            switch error.detail {
            case "Too many login attempts. Please wait a moment before trying again...":
                errorMessage = "Quota de tentative de connexion atteint. Veuillez attendre quelques minutes."
            case "Invalid credentials":
                errorMessage = "Identifiant ou mot de passe incorrect"
            default:
                errorMessage = error.detail
            }
            password = ""
        } catch {
            errorMessage = error.localizedDescription
        }

        isLogginLoading = false
    }
}
