//
//  LoginFormView.swift
//  penpal
//

import SwiftUI

struct LoginFormView: View {
    @StateObject var viewModel: LoginViewModel
    @State private var showErrorAlert = false

    var body: some View {
        Form {
            TextField(
                "Nom d'utilisateur",
                text: $viewModel.username
            )
            .textFieldStyle(DefaultTextFieldStyle())
            .keyboardType(.emailAddress)
            .autocorrectionDisabled(true)
            .autocapitalization(.none)
            .padding(8)
            SecureField(
                "Mot de passe",
                text: $viewModel.password
            )
            .textFieldStyle(DefaultTextFieldStyle())
            .autocorrectionDisabled(true)
            .autocapitalization(.none)
            .padding(8)

            HStack {
                StdButton(
                    label: "Connexion",
                    label_color: .white,
                    background: .blue,
                    disabled: viewModel.isLogginLoading
                ) {
                    Task {
                        await viewModel.login()
                    }
                }
            }
        }
        .navigationTitle("Connexion")
        .onReceive(viewModel.$errorMessage) { error in
            showErrorAlert = error != nil
        }
        .alert(
            "Erreur",
            isPresented: $showErrorAlert,
            actions: {
                Button("OK", role: .cancel) {
                    viewModel.errorMessage = nil
                }
            },
            message: {
                Text(
                    viewModel.errorMessage
                        ?? "Une erreur inconnue est survenue."
                )
            }
        )
    }
}
