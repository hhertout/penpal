//
//  MessagesView.swift
//  penpal
//

import SwiftUI

struct Topbar: View {
    @Environment(\.dismiss) private var dismiss
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
            .labelsHidden()

            Spacer()
            VStack {
                Avatar(name: self.name)
                Text(self.name)
                    .fontWeight(.bold)
                    .font(.title3)
            }
            Spacer()
        }.padding()
    }
}

struct MessagesView: View {
    @StateObject var viewModel: MessagesViewModel
    var name: String
    var conversationId: String

    init(conversationId: String, name: String) {
        self.conversationId = conversationId
        self.name = name

        _viewModel = StateObject(
            wrappedValue: MessagesViewModel(convId: conversationId)
        )
    }

    var body: some View {
        VStack {
            Topbar(name: name)

            MessageListView(messages: viewModel.messages)
            
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    Text("\(name) is writing...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .italic()
                        .padding(.trailing, 10)
                        .padding(.vertical, 6)
                }
                .opacity(0.8)
                .padding(.horizontal, 24)
                .transition(.opacity)
                    .animation(.easeInOut(duration: 1), value: viewModel.isLoading)
            }
            
            Spacer()
            HStack(alignment: .center) {
                TextField(
                    "Text Message...",
                    text: $viewModel.sendMessageModel.message
                )
                .padding(8)
                .padding(.horizontal, 12)
                .background()
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
                if viewModel.sendMessageModel.message != "" {
                    Button {
                        Task {
                            await viewModel.sendMessage()
                        } 
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .padding(6)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 6)

        }
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.getMessages(convId: conversationId)
        }
    }
}

#Preview {
    MessagesView(conversationId: "toto", name: "toto")
}
