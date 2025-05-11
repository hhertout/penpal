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

    @Published var isLoggedIn: Bool = false

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private var cancellables: Set<AnyCancellable> = []

    init() {
        checkAuthentication()
    }

    func checkAuthentication() {
        self.isLoading = true
        if let token = KeychainHelper.shared.read(
            service: "app",
            account: "token"
        ), !token.isEmpty {
            // TODO = CHECK TOKEN IS VALID WITH API !
            self.isLoggedIn = true
            self.isLoading = false
        }

        self.isLoading = false
    }

    func login() {
        isLoading = true
        errorMessage = nil
        
        if password == "" || username == "" {
            errorMessage = "Please fill all fields"
            
            isLoading = false
            return
        }

        var request = URLRequest(
            url: URL(string: "\(Constants.BACKEND_URL)/api/v1/login")!
        )
        request.httpMethod = "POST"

        let body = ["username": username, "password": password]
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200
                else {
                    if let serverError = try? JSONDecoder().decode(
                        ServerError.self,
                        from: data
                    ) {
                        throw serverError
                    } else {
                        let err = ServerError(detail: "Unknown error. Status code \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                        throw err
                    }
                }

                return data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: AuthResponse.self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .failure(let error):
                    if let serverError = error as? ServerError {
                        print(serverError)
                        self.errorMessage = serverError.detail
                    } else {
                        self.errorMessage = error.localizedDescription
                    }
                    
                    self.password = ""
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { data in
                print("Data received \(data)")
                KeychainHelper.shared.save(data.token, service: "auth", account: "token")
                self.isLoading = false
                self.isLoggedIn = true
            }
            .store(in: &cancellables)
    }
}
