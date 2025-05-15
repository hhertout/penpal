//
//  ConversationwView.swift
//  penpal
//

import SwiftUI

struct ConversationwView: View {
    @StateObject var viewModel = ConversationViewModel()
    @State var showAddConversationSheet: Bool = false

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("Chargement...")
            } else if let error = viewModel.errorMessage {
                Text("Erreur : \(error)")
            } else if viewModel.conversations.count > 0 {
                List(viewModel.conversations) { conv in
                    Text(conv.name)
                }
            } else {
                NoConversationView()
            }
        }
        .navigationTitle("Conversations")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showAddConversationSheet = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .task {
            await viewModel.getConversations()
        }
        .sheet(isPresented: $showAddConversationSheet) {
            NavigationStack {
                AddConversationView(
                    onCancel: { showAddConversationSheet = false },
                    onCreate: { showAddConversationSheet = false }
                )
            }
        }
    }
}

#Preview {
    ConversationwView()
}
