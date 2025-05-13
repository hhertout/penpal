//
//  ContentView.swift
//  penpal
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: LoginViewModel
    @EnvironmentObject var session: Session
    
    init(session: Session) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(session: session))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(2)
                } else if session.isLoggedIn {
                    HomeView()
                } else {
                    VStack {
                        LoginView(viewModel: viewModel)
                    }
                }
            }
            .task {
                await viewModel.checkAuthentication()
            }
        }
    }
}

#Preview {
    let session = Session()
    ContentView(session: session)
        .environmentObject(session)
}
