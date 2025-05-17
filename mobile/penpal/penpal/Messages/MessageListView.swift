//
//  MessageListView.swift
//  penpal
//

import SwiftUI

public struct MessageListView: View {
    var messages: [MessageModel]

    public var body: some View {
        ScrollViewReader { proxy in
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages.sorted { $0.ts > $1.ts }) { message in
                            MessageBubble(
                                message: message.message,
                                isSentByCurrentUser: message.sender == "user"
                            )
                            .rotationEffect(.degrees(180))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
                .rotationEffect(.degrees(180))
            }
        }
    }
}

#Preview {
    let messages = [
        MessageModel(
            id: "682077b0220be40999280f08",
            message:
                "Hey! I'm doing good, just chilling here in New York. How's life in France?\n",
            sender: "ai",
            ts: 1_746_958_256,
            correction:
                "Your message looks great! It's already correct:\n\n\n\"Hello, how are you?\"\n\nFeel free to ask if there's anything else I can assist with in French (or English)! Just let me know what you're interested in or need help with today. I'm here for it! 😊\n\n\n--- End of correction ---",
        ),
        MessageModel(
            id: "682077a9220be40999280f06",
            message: "Hello, how are you ?",
            sender: "user",
            ts: 1_746_958_249,
        ),
    ]

    MessageListView(messages: messages)
}
