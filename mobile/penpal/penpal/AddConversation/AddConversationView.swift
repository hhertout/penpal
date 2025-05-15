//
//  AddConversationView.swift
//  penpal
//
//  Created by Hugues Hertout on 15/05/2025.
//

import SwiftUI

struct AddConversationView: View {
    @State private var name: String = ""
    @StateObject var viewModel = AddConversationViewModel()

    var onCancel: () -> Void
    var onCreate: () -> Void

    var body: some View {
        Form {
            Section(header: Text("Informations")) {
                VStack(alignment: .leading) {
                    Label("Nom", systemImage: "person")
                    TextField("Entrez le nom", text: $viewModel.model.name)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Nouveau contact")
                    .fontWeight(.bold)
                    .font(.title3)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    onCancel()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Créer") {
                    onCreate()
                }
                .fontWeight(.bold)
            }
        }
    }
}

#Preview {
    AddConversationView(
        onCancel: {},
        onCreate: {}
    )
}
