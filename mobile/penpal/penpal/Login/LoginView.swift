//
//  LoginView.swift
//  penpal
//

import SwiftUI

struct LoginView: View {

    var body: some View {
        NavigationView {
            ZStack {
                FormView()
            }
            .contentMargins(.vertical, 12)
            .contentMargins(.horizontal, 12)
        }
    }
}

struct FormView: View {
    @StateObject var viewModel = LoginViewModel()
    var body: some View {
        Form {
            TextField(
                "Nom d'utilisateur",
                text: $viewModel.email
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
                    background: .blue
                ) {
                    viewModel.login()
                }
            }
        }
        .navigationTitle("Connexion")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
