//
//  LoginFormView.swift
//  penpal
//

import SwiftUI

struct LoginFormView: View {
    @StateObject var viewModel: LoginViewModel
    
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
            
            if viewModel.errorMessage != nil {
                HStack {
                    Text(viewModel.errorMessage!)
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                }
            }

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
