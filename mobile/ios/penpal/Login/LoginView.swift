//
//  LoginView.swift
//  penpal
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel

    var body: some View {
        NavigationView {
            ZStack {
                LoginFormView(viewModel: viewModel)
            }
        }
    }
}
