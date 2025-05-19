//
//  ContentView.swift
//  penpal
//

import SwiftUI

struct ContentView: View {
    @StateObject var appViewModel: AppViewModel
    @StateObject var viewModel: LoginViewModel
    @EnvironmentObject var session: Session
    
    init(session: Session) {
        _appViewModel = StateObject(wrappedValue: AppViewModel())
        _viewModel = StateObject(wrappedValue: LoginViewModel(session: session))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if appViewModel.isAppAlive == false {
                    NoConnectionView() {
                        Task {
                            await appViewModel.checkAppHealth()
                        }
                    }
                } else {
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
            }
            .task {
                await appViewModel.checkAppHealth()
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
