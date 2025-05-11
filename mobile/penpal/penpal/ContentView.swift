//
//  ContentView.swift
//  penpal
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = LoginViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoggedIn {
                    HomeView()
                } else {
                    VStack {
                        LoginView(viewModel: viewModel)
                    }.blur(radius: viewModel.isLoading ? 3 : 0)
                        .disabled(viewModel.isLoading)
                        .onAppear {
                            viewModel.checkAuthentication()
                        }

                }
            }
        }
    }
}

#Preview {
    ContentView()
}
