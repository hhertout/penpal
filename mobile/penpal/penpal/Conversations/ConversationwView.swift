//
//  ConversationwView.swift
//  penpal
//

import SwiftUI

struct ConversationwView: View {
    @StateObject var viewModel = ConversationViewModel()

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("Chargement...")
            } else if let error = viewModel.errorMessage {
                Text("Erreur : \(error)")
            } else {
                List(viewModel.conversations) { conv in
                    Text(conv.name)
                }
            }
        }
        .task {
            await viewModel.getConversations()
        }
    }
}

#Preview {
    ConversationwView()
}
