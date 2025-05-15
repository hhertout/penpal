//
//  NoConversationView.swift
//  penpal
//

import SwiftUI

struct NoConversationView: View {
    @State var showAddConversationSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 18) {
                Image(systemName: "exclamationmark.message.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                Text("Aucune conversation pour le mmoment")
            }
            
            Button{
                showAddConversationSheet = true
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Nouvelle conversation")
                }
            }
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
    NoConversationView()
}
